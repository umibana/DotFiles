;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Hans Villarroel"
      user-mail-address "hans.villarroel@hotmail.cl")

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 tab-width 4                                                         ; Set width for tabs
 uniquify-buffer-name-style 'forward      ; Uniquify buffer names
 window-combination-resize t                    ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                                           ; Stretch cursor to the glyph width

(setq undo-limit 80000000                          ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                             ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                                    ; Nobody likes to loose work, I certainly don't
      inhibit-compacting-font-caches t      ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…"               ; Unicode ellispis are nicer than "...", and also save /precious/ space
      scroll-margin 2)

(delete-selection-mode 1)                             ; Replace selection when inserting text
(display-time-mode 1)                                   ; Enable time in the mode-line
(global-subword-mode 1)                           ; Iterate through CamelCase words
(global-undo-tree-mode)                           ; Vim like undo instead of emacs one
(setq line-spacing 0.3)                                   ; seems like a nice line spacing balance.

(unless (string-match-p "^Power N/A" (battery))   ; On laptops...
  (display-battery-mode 1))                       ; it's nice to know how much power you have


(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))
(setq +ivy-buffer-preview t)

(setq-default major-mode 'org-mode) ;; New buffers in org-mode instead of fundamental mode

(defun doom-modeline-conditional-buffer-encoding ()
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(map! :map evil-window-map
      "SPC" #'rotate-layout
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

(map! :after evil-easymotion
      :map evilem-map
      :desc "Jump to char" "f" #'evil-avy-goto-char)

(setq frame-title-format
      '(""
	(:eval
	 (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
           "%b"))
	(:eval
	 (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-big-font (font-spec :family "Iosevka" :size 24)
      doom-variable-pitch-font (font-spec :family "Iosevka" :size 16)
      doom-unicode-font (font-spec :family "Iosevka")
      doom-serif-font (font-spec :family "Iosevka Term" :weight 'light))
;;light themes
					;(setq doom-theme 'doom-gruvbox-light)
					;(setq doom-theme 'zaiste)
					;(setq doom-theme 'doom-flatwhite)
;;dark themes
(setq-default indent-tabs-mode t)
(setq doom-theme 'doom-dimmedwave)

(setq display-line-numbers-type nil)

(setq org-directory "~/Documents/Estudios/org-notes/")

; Generate phrases on doom dashboard
(defvar phrase-api-url
  (nth (random 3)
       '(("https://corporatebs-generator.sameerkumar.website/" :phrase)
         ("https://useless-facts.sameerkumar.website/api" :data)
         ("https://dev-excuses-api.herokuapp.com/" :text))))

(defmacro phrase-generate-callback (token &optional format-fn ignore-read-only callback buffer-name)
  `(lambda (status)
     (unless (plist-get status :error)
       (goto-char url-http-end-of-headers)
       (let ((phrase (plist-get (json-parse-buffer :object-type 'plist) (cadr phrase-api-url)))
             (inhibit-read-only ,(when (eval ignore-read-only) t)))
         (setq phrase-last (cons phrase (float-time)))
         (with-current-buffer ,(or (eval buffer-name) (buffer-name (current-buffer)))
           (save-excursion
             (goto-char (point-min))
             (when (search-forward ,token nil t)
               (with-silent-modifications
                 (replace-match "")
                 (insert ,(if format-fn format-fn 'phrase)))))
           ,callback)))))

(defvar phrase-last nil)
(defvar phrase-timeout 5)

(defmacro phrase-insert-async (&optional format-fn token ignore-read-only callback buffer-name)
  `(let ((inhibit-message t))
     (if (and phrase-last
              (> phrase-timeout (- (float-time) (cdr phrase-last))))
         (let ((phrase (car phrase-last)))
           ,(if format-fn format-fn 'phrase))
       (url-retrieve (car phrase-api-url)
                     (phrase-generate-callback ,(or token "\ufeff") ,format-fn ,ignore-read-only ,callback ,buffer-name))
       ;; For reference, \ufeff = Zero-width no-break space / BOM
       ,(or token "\ufeff"))))

(defun doom-dashboard-phrase ()
  (phrase-insert-async
   (progn
     (setq-local phrase-position (point))
     (mapconcat
      (lambda (line)
        (+doom-dashboard--center
         +doom-dashboard--width
         (with-temp-buffer
           (insert-text-button
            line
            'action
            (lambda (_)
              (setq phrase-last nil)
              (+doom-dashboard-reload t))
            'face 'doom-dashboard-menu-title
            'mouse-face 'doom-dashboard-menu-title
            'help-echo "Random phrase"
            'follow-link t)
           (buffer-string))))
      (split-string
       (with-temp-buffer
         (insert phrase)
         (setq fill-column (min 70 (/ (* 2 (window-width)) 3)))
         (fill-region (point-min) (point-max))
         (buffer-string))
       "\n")
      "\n"))
   nil t
   (progn
     (goto-char phrase-position)
     (forward-whitespace 1))
   +doom-dashboard-name))

(defadvice! doom-dashboard-widget-loaded-with-phrase ()
  :override #'doom-dashboard-widget-loaded
  (setq line-spacing 0.2)
  (insert
   "\n\n"
   (propertize
    (+doom-dashboard--center
     +doom-dashboard--width
     (doom-display-benchmark-h 'return))
    'face 'doom-dashboard-loaded)
   "\n"
   (doom-dashboard-phrase)
   "\n"))

(defun doom-dashboard-draw-ascii-emacs-banner-fn ()
  (let* ((banner
          '(",---.,-.-.,---.,---.,---."
            "|---'| | |,---||    `---."
            "`---'` ' '`---^`---'`---'"))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat
                 line (make-string (max 0 (- longest-line (length line)))
                                   32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(unless (display-graphic-p) ; for some reason this messes up the graphical splash screen atm
  (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn))

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(add-hook! '+doom-dashboard-mode-hook (hide-mode-line-mode 1) (hl-line-mode -1))
(setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))

(load! "splash")
;;(use-package! org-ref
;;    :after org
;;    :init
;;    ; code to run before loading org-ref
;;    :config
;;    ; code to run after loading org-ref
;;    )
;;(setq org-ref-notes-directory "~/Documents/Estudios/org-notes"
;;     ; org-ref-bibliography-notes "~/Documents/Estudios/org-notes/references/articles.org" ;; not needed anymore. Notes now taken in org-roaM
;;      org-ref-default-bibliography '("~/Documents/Estudios/org-notes/references/library.bib")
;;      org-ref-pdf-directory "~/Documents/Estudios/Zotero/")

(after! org
  (setq org-log-done 'time))

(after! org
  (setq org-capture-templates
        '(("t" "TODO" entry (file+headline "~/Documents/Estudios/org-notes/gtd.org" "Collect")
           "* TODO %? %^G \n  %U" :empty-lines 1)
          ("s" "Scheduled TODO" entry (file+headline "~/Documents/Estudios/org-notes/gtd.org" "Collect")
           "* TODO %? %^G \nSCHEDULED: %^t\n  %U" :empty-lines 1)
          ("d" "Deadline" entry (file+headline "~/Documents/Estudios/org-notes/gtd.org" "Collect")
           "* TODO %? %^G \n  DEADLINE: %^t" :empty-lines 1)
          ("u" "Urgent" entry (file+headline "~/Documents/Estudios/org-notes/gtd.org" "Collect")
           "* TODO [#A] %? %^G \n  SCHEDULED: %^t")
          ("a" "Appointment" entry (file+headline "~/Documents/Estudios/org-notes/gtd.org" "Collect")
           "* %? %^G \n  %^t")
          ("l" "Link" entry (file+headline "~/Documents/Estudios/org-notes/gtd.org" "Collect")
           "* TODO %a %? %^G\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n")
          ("n" "Note" entry (file+headline "~/Documents/Estudios/org-notes/notes.org" "Notes")
           "* %? %^G\n%U" :empty-lines 1)
	  ("p" "Protocol" entry (file+headline "~/Documents/Estudios/org-notes/notes.org" "Captures")
           "* %^{Title} %^G\nSource: %u, [[%:link][%:description]]\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
	  ("L" "Protocol Link" entry (file+headline "~/Documents/Estudios/org-notes/notes.org" "Links")
           "* %? %^G \n[[%:link][%:description]] \nCaptured On: %U")
          ("j" "Journal" entry (file+datetree "~/Documents/Estudios/org-notes/journal/journal.org")
           "* %? %^G\nEntered on %U\n"))))



;;(use-package! helm-bibtex
;;  :after org
;;  :init
;;  ; blah blah
;;  :config
;;  ;blah blah
;;  )
;;
;;(setq bibtex-format-citation-functions
;;      '((org-mode . (lambda (x) (insert (concat
;;                                         "\\cite{"
;;                                         (mapconcat 'identity x ",")
;;                                         "}")) ""))))
;;(setq
;;      bibtex-completion-pdf-field "file"
;;      bibtex-completion-bibliography
;;      '("~/Documents/Estudios/org-notes/references/library.bib")
;;      bibtex-completion-library-path '("~/Documents/Estudios/Zotero/")
;;     ; bibtex-completion-notes-path "~/Documents/Estudios/org-notes/references/articles.org"  ;; not needed anymore as I take notes in org-roam


(setf mouse-wheel-scroll-amount '(3 ((shift) . 3))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse t
      scroll-step 1
      scroll-conservatively 100
      disabled-command-function nil)

(after! doom-modeline
  (doom-modeline-def-segment buffer-name
    "Display the current buffer's name, without any other information."
    (concat
     (doom-modeline-spc)
     (doom-modeline--buffer-name)))

  (doom-modeline-def-segment pdf-icon
    "PDF icon from all-the-icons."
    (concat
     (doom-modeline-spc)
     (doom-modeline-icon 'octicon "file-pdf" nil nil
                         :face (if (doom-modeline--active)
                                   'all-the-icons-red
                                 'mode-line-inactive)
                         :v-adjust 0.02)))

  (defun doom-modeline-update-pdf-pages ()
    "Update PDF pages."
    (setq doom-modeline--pdf-pages
          (let ((current-page-str (number-to-string (eval `(pdf-view-current-page))))
                (total-page-str (number-to-string (pdf-cache-number-of-pages))))
            (concat
             (propertize
              (concat (make-string (- (length total-page-str) (length current-page-str)) ? )
                      " P" current-page-str)
              'face 'mode-line)
             (propertize (concat "/" total-page-str) 'face 'doom-modeline-buffer-minor-mode)))))

  (doom-modeline-def-segment pdf-pages
    "Display PDF pages."
    (if (doom-modeline--active) doom-modeline--pdf-pages
      (propertize doom-modeline--pdf-pages 'face 'mode-line-inactive)))

  (doom-modeline-def-modeline 'pdf
    '(bar window-number pdf-pages pdf-icon buffer-name)
    '(misc-info matches major-mode process vcs)))

;;(use-package! zotxt
;; :after org)
;;(add-to-list 'load-path (expand-file-name "ox-pandoc" starter-kit-dir))

;;(use-package! ox-pandoc
;;  :after org)
;;;; default options for all output formats
;;(setq org-pandoc-options '((standalone . _)))
;;;; cancel above settings only for 'docx' format
;;(setq org-pandoc-options-for-docx '((standalone . nil)))
;;;; special settings for beamer-pdf and latex-pdf exporters
;;(setq org-pandoc-options-for-beamer-pdf '((pdf-engine . "xelatex")))
;;(setq org-pandoc-options-for-latex-pdf '((pdf-engine . "pdflatex")))
;;;; special extensions for markdown_github output
;;(setq org-pandoc-format-extensions '(markdown_github+pipe_tables+raw_html))
;;
;;(use-package! org-roam-bibtex
;;  :load-path "~/Documents/Estudios/org-notes/references/library.bib" ;Modify with your own path
;;  :hook (org-roam-mode . org-roam-bibtex-mode)
;;  :bind (:map org-mode-map
;;         (("C-c n a" . orb-note-actions))))
;;(setq orb-templates
;;      '(("r" "ref" plain (function org-roam-capture--get-point) ""
;;         :file-name "${citekey}"
;;         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n" ; <--
;;         :unnarrowed t)))
;;(setq orb-preformat-keywords   '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))
;;
;;(setq orb-templates
;;      '(("n" "ref+noter" plain (function org-roam-capture--get-point)
;;         ""
;;         :file-name "${slug}"
;;         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n#+ROAM_TAGS:
;;
;;- tags ::
;;- keywords :: ${keywords}
;;\* ${title}
;;:PROPERTIES:
;;:Custom_ID: ${citekey}
;;:URL: ${url}
;;:AUTHOR: ${author-or-editor}
;;:NOTER_DOCUMENT: %(orb-process-file-field \"${citekey}\")
;;:NOTER_PAGE:
;;:END:")))

					; org-roam settings
(setq org-roam-directory "~/Documents/Estudios/org-notes")
(after! org-roam
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
        :desc "org-roam-find-file" "f" #'org-roam-find-file
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-capture" "c" #'org-roam-capture))
(after! org-roam
  (setq org-roam-ref-capture-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "websites/${slug}"
           :head "#+TITLE: ${title}
    #+ROAM_KEY: ${ref}
    - source :: ${ref}"
           :unnarrowed t))))  ; capture template to grab websites. Requires org-roam protocol.

;; org-journal the DOOM way
(use-package org-journal
  :init
  (setq org-journal-dir "~/Documents/Estudios/org-notes/Daily/"
        org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-date-format "%A, %d %B %Y")
  :config
  (setq org-journal-find-file #'find-file-other-window )
  (map! :map org-journal-mode-map
        "C-c n s" #'evil-save-modified-and-close )
  )

(setq org-journal-enable-agenda-integration t)

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Documents/Estudios/org-notes"))


(use-package! org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-export-inline-images t
        org-roam-server-authenticate nil
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20)
  (defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interactive)
    (org-roam-server-mode 1)
    (browse-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))
(after! org-roam
  (org-roam-server-mode))

(use-package! org-download
  :after org
  :bind
  (:map org-mode-map
   (("s-Y" . org-download-screenshot)
    ("s-y" . org-download-yank))))

					;(after! centaur-tabs
					; (centaur-tabs-mode -1)
					;(setq centaur-tabs-height 36
					;     centaur-tabs-set-icons t
					;    centaur-tabs-modified-marker "o"
					;   centaur-tabs-close-button "×"
					;  centaur-tabs-set-bar 'above)
					; centaur-tabs-gray-out-icons 'buffer
					;(centaur-tabs-change-fonts "P22 Underground Book" 160))
;; (setq x-underline-at-descent-line t)

(use-package! org-pretty-table
  :commands (org-pretty-table-mode global-org-pretty-table-mode))
(use-package! org-ol-tree
  :commands org-ol-tree)
(map! :map org-mode-map
      :after org
      :localleader
      :desc "Outline" "O" #'org-ol-tree)
(use-package! ox-gfm
  :after org)

(use-package! org-fancy-priorities
					; :ensure t
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(use-package! cdlatex
  :after (:any org-mode LaTeX-mode)
  :hook
  ((LaTeX-mode . turn-on-cdlatex)
   (org-mode . turn-on-org-cdlatex)))


(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)
(setq org-agenda-files (directory-files-recursively "~/Documents/Estudios/" "\\.org$"))
(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :todo "TODAY"
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                           :todo "NEXT"
                           :order 1)
                          (:name "Important"
                           :tag "Important"
                           :priority "A"
                           :order 1)
                          (:name "Due Today"
                           :deadline today
                           :order 2)
                          (:name "Due Soon"
                           :deadline future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :face error
                           :order 7)
                          (:name "Work"
                           :tag "Work"
                           :order 3)
                          (:name "Dissertation"
                           :tag "Dissertation"
                           :order 7)
                          (:name "Emacs"
                           :tag "Emacs"
                           :order 13)
                          (:name "Projects"
                           :tag "Project"
                           :order 14)
                          (:name "Essay 1"
                           :tag "Essay1"
                           :order 2)
                          (:name "Reading List"
                           :tag "Read"
                           :order 8)
                          (:name "Work In Progress"
                           :tag "WIP"
                           :order 5)
                          (:name "Blog"
                           :tag "Blog"
                           :order 12)
                          (:name "Essay 2"
                           :tag "Essay2"
                           :order 3)
                          (:name "Trivial"
                           :priority<= "E"
                           :tag ("Trivial" "Unimportant")
                           :todo ("SOMEDAY" )
                           :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-journal-date-format "%A, %d %B %Y" t)
 '(org-journal-date-prefix "#+TITLE: " t)
 '(org-journal-dir "~/Documents/Estudios/org-notes/Daily/" t)
 '(org-journal-file-format "%d-%m-%Y.org" t)
 '(package-selected-packages (quote (org-fancy-priorities))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((type tty))))))

;; adding custom key-bindings for most used functions
;;(map! :leader "f a"#'helm-bibtex)  ; "find article" : opens up helm bibtex for search.
(map! :leader "o n"#'org-noter)    ; "org noter"  : opens up org noter in a headline
(map! :leader "r c i"#'org-clock-in); "routine clock in" : clock in to a habit.
(map! :leader "c b"#'beacon-blink) ; "cursor blink" : makes the beacon-blink

(use-package! org
  :config
  (setq
					; org-bullets-bullet-list '("⁖")
   org-todo-keyword-faces
   '(("TODO" :foreground "#7c7c75" :weight normal :underline t)
     ("WAITING" :foreground "#9f7efe" :weight normal :underline t)
     ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
     ("DONE" :foreground "#50a14f" :weight normal :underline t)
     ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))
   org-priority-faces '((65 :foreground "#e45649")
                        (66 :foreground "#da8548")
                        (67 :foreground "#0098dd"))
   ))

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.

					;(use-package! org-xournalpp
					;  :config
					;  (add-hook 'org-mode-hook 'org-xournalpp-mode))
(setq-default history-length 1000) ; remembering history from precedent
(setq-default prescient-history-length 1000)
(set-company-backend!
  '(text-mode
    markdown-mode
    gfm-mode)
  '(:seperate
    company-ispell
    company-files
    company-yasnippet))

(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

;; Org-mode strike trough done
(set-face-attribute 'org-headline-done nil :strike-through t)
;; Function to remove links but keep description
(defun afs/org-replace-link-by-link-description ()
  "Replace an org link by its description or if empty its address"
  (interactive)
  (if (org-in-regexp org-link-bracket-re 1)
      (save-excursion
        (let ((remove (list (match-beginning 0) (match-end 0)))
              (description
               (if (match-end 2)
                   (org-match-string-no-properties 2)
                 (org-match-string-no-properties 1))))
          (apply 'delete-region remove)
          (insert description)))))

(setq org-columns-default-format
      "%25ITEM %TODO %3PRIORITY %TIMESTAMP %DEADLINE %SCHEDULED")
(setq org-agenda-prefix-format
      '((agenda . " %i %-12:c%?-12t% s")
	(todo . " %i %-12:c")
	(tags . " %i %-12:c")
	(Date . " %s %-12:c")
	(search . " %i %-12:c")))
(setq lsp-ui-doc-enable t)
(setq lsp-eldoc-hook nil)
(setq lsp-ui-doc-delay 2)

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer :contents-sources
			    (list
			     (cfw:org-create-source "Green")  ; orgmode source
			     (cfw:cal-create-source "Orange") ; diary source)
			     )))
(defun meain/evil-delete-advice (orig-fn beg end &optional type _ &rest args)
  "Make d, c, x to not write to clipboard."
  (apply orig-fn beg end type ?_ args))

(advice-add 'evil-delete :around 'meain/evil-delete-advice)
(advice-add 'evil-change :around 'meain/evil-delete-advice)
(defun ar/org-insert-link-dwim ()
  "Like `org-insert-link' but with personal dwim preferences."
  (interactive)
  (let* ((point-in-link (org-in-regexp org-link-any-re 1))
         (clipboard-url (when (string-match-p "^http" (current-kill 0))
                          (current-kill 0)))
         (region-content (when (region-active-p)
                           (buffer-substring-no-properties (region-beginning)
                                                           (region-end)))))
    (cond ((and region-content clipboard-url (not point-in-link))
           (delete-region (region-beginning) (region-end))
           (insert (org-make-link-string clipboard-url region-content)))
          ((and clipboard-url (not point-in-link))
           (insert (org-make-link-string
                    clipboard-url
                    (read-string "title: "
                                 (with-current-buffer (url-retrieve-synchronously clipboard-url)
                                   (dom-text (car
                                              (dom-by-tag (libxml-parse-html-region
                                                           (point-min)
                                                           (point-max))
                                                          'title))))))))
          (t
           (call-interactively 'org-insert-link)))))

(use-package! info-colors
  :commands (info-colors-fontify-node))
(add-hook 'Info-selection-hook 'info-colors-fontify-node)


(use-package! org-pomodoro
  :commands (org-pomodoro)
  :config
  (setq
   alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil)))
   org-pomodoro-length 25
   org-pomodoro-short-break-length 5
   ))

(defun org-pomodoro-prompt ()
  (interactive)
  (org-clock-goto)
  (if (y-or-n-p "Start a new pomodoro?")
      (progn
	(org-pomodoro))))
(setq-hook! 'web-mode-hook +format-with 'prettier)


(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")
(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))
(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)

(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)
  (setq mixed-pitch-set-height t)
  (setq variable-pitch-serif-font (font-spec :family "Iosevka" :size 27))
  (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (let ((mixed-pitch-face 'variable-pitch-serif))
      (mixed-pitch-mode (or arg 'toggle)))))

(setq projectile-ignored-projects '("~/" "/tmp" "~/.emacs.d/.local/straight/repos/"))
(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is within any of `projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))

(setq which-key-idle-delay 0.5) ;; I need the help, I really do
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

(setq +zen-text-scale 0.8)
(defvar +zen-serif-p t
  "Whether to use a serifed font with `mixed-pitch-mode'.")
(after! writeroom-mode
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  (defvar-local +zen--original-org-pretty-table-mode-p nil)
  (defun +zen-enable-mixed-pitch-mode-h ()
    "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
    (when (apply #'derived-mode-p +zen-mixed-pitch-modes)
      (if writeroom-mode
          (progn
            (setq +zen--original-mixed-pitch-mode-p mixed-pitch-mode)
            (funcall (if +zen-serif-p #'mixed-pitch-serif-mode #'mixed-pitch-mode) 1))
        (funcall #'mixed-pitch-mode (if +zen--original-mixed-pitch-mode-p 1 -1)))))
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width
            'org-adapt-indentation
            'org-superstar-headline-bullets-list
            'org-superstar-remove-leading-stars)
  (add-hook 'writeroom-mode-enable-hook
            (defun +zen-prose-org-h ()
              "Reformat the current Org buffer appearance for prose."
              (when (eq major-mode 'org-mode)
                (setq display-line-numbers nil
                      visual-fill-column-width 60
                      org-adapt-indentation nil)
                (when (featurep 'org-superstar)
                  (setq-local org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
                              ;; org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                              org-superstar-remove-leading-stars t)
                  (org-superstar-restart))
                (setq
                 +zen--original-org-indent-mode-p org-indent-mode
                 +zen--original-org-pretty-table-mode-p (bound-and-true-p org-pretty-table-mode))
                (org-indent-mode -1)
                (org-pretty-table-mode 1))))
  (add-hook 'writeroom-mode-disable-hook
            (defun +zen-nonprose-org-h ()
              "Reverse the effect of `+zen-prose-org'."
              (when (eq major-mode 'org-mode)
                (when (featurep 'org-superstar)
                  (org-superstar-restart))
                (when +zen--original-org-indent-mode-p (org-indent-mode 1))
                ;; (unless +zen--original-org-pretty-table-mode-p (org-pretty-table-mode -1))
                ))))

(setq yas-triggers-in-field t)

(after! org-superstar
  (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-superstar-prettify-item-bullets t ))

(setq org-ellipsis " ▾ "
      org-hide-leading-stars t
      org-priority-highest ?A
      org-priority-lowest ?E
      org-priority-faces
      '((?A . 'all-the-icons-red)
        (?B . 'all-the-icons-orange)
        (?C . 'all-the-icons-yellow)
        (?D . 'all-the-icons-green)
        (?E . 'all-the-icons-blue)))

(appendq! +ligatures-extra-symbols
          `(:checkbox      "☐"
            :pending       "◼"
            :checkedbox    "☑"
            :list_property "∷"
            :em_dash       "—"
            :ellipses      "…"
            :arrow_right   "→"
            :arrow_left    "←"
            :title         "𝙏"
	    :roam_tags     "蛇"
            :subtitle      "𝙩"
            :author        "𝘼"
            :date          "𝘿"
            :property      "☸"
            :options       "⌥"
            :startup       "⏻"
            :macro         "𝓜"
            :html_head     "🅷"
            :html          "🅗"
            :latex_class   "🄻"
            :latex_header  "🅻"
            :beamer_header "🅑"
            :latex         "🅛"
            :attr_latex    "🄛"
            :attr_html     "🄗"
            :attr_org      "⒪"
            :begin_quote   "❝"
            :end_quote     "❞"
            :caption       "☰"
            :header        "›"
            :results       "🠶"
            :begin_export  "⏩"
            :end_export    "⏪"
            :properties    "⚙"
            :end           "∎"
            :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
            :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
            :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
            :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
            :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)))
(set-ligatures! 'org-mode
  :merge t
  :checkbox      "[ ]"
  :pending       "[-]"
  :checkedbox    "[X]"
  :list_property "::"
  :em_dash       "---"
  :ellipsis      "..."
  :arrow_right   "->"
  :arrow_left    "<-"
  :roam_tags     "#+roam_tags:"
  :title         "#+title:"
  :subtitle      "#+subtitle:"
  :author        "#+author:"
  :date          "#+date:"
  :property      "#+property:"
  :options       "#+options:"
  :startup       "#+startup:"
  :macro         "#+macro:"
  :html_head     "#+html_head:"
  :html          "#+html:"
  :latex_class   "#+latex_class:"
  :latex_header  "#+latex_header:"
  :beamer_header "#+beamer_header:"
  :latex         "#+latex:"
  :attr_latex    "#+attr_latex:"
  :attr_html     "#+attr_html:"
  :attr_org      "#+attr_org:"
  :begin_quote   "#+begin_quote"
  :end_quote     "#+end_quote"
  :caption       "#+caption:"
  :header        "#+header:"
  :begin_export  "#+begin_export"
  :end_export    "#+end_export"
  :results       "#+RESULTS:"
  :property      ":PROPERTIES:"
  :end           ":END:"
  :priority_a    "[#A]"
  :priority_b    "[#B]"
  :priority_c    "[#C]"
  :priority_d    "[#D]"
  :priority_e    "[#E]")
(plist-put +ligatures-extra-symbols :name "⁍")

(setq org-latex-pdf-process '("latexmk -f -pdf -%latex -shell-escape -interaction=nonstopmode -output-directory=%o %f"))
(after! ox-latex
  (add-to-list 'org-latex-classes
               '("scr-article"
                 "\\documentclass{scrartcl}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("blank"
                 "[NO-DEFAULT-PACKAGES]\n[NO-PACKAGES]\n[EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("bmc-article"
                 "\\documentclass[article,code,maths]{bmc}\n[NO-DEFAULT-PACKAGES]\n[NO-PACKAGES]\n[EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("bmc"
                 "\\documentclass[code,maths]{bmc}\n[NO-DEFAULT-PACKAGES]\n[NO-PACKAGES]\n[EXTRA]"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(setq org-latex-default-class "scr-article"
      org-latex-tables-booktabs t
      org-latex-hyperref-template "
<<latex-fancy-hyperref>>
"
      org-latex-reference-command "\\cref{%s}")

(add-hook 'org-mode-hook #'+org-pretty-mode)
(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.15)
  '(outline-2 :weight bold :height 1.12)
  '(outline-3 :weight bold :height 1.10)
  '(outline-4 :weight semi-bold :height 1.07)
  '(outline-5 :weight semi-bold :height 1.05)
  '(outline-6 :weight semi-bold :height 1.03)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold))

(custom-set-faces!
  '(org-document-title :height 1.2))
(setq org-agenda-deadline-faces
      '((1.001 . error)
        (1.0 . org-warning)
        (0.5 . org-upcoming-deadline)
        (0.0 . org-upcoming-distant-deadline)))

(setq org-export-headline-levels 5) ; I like nesting

(defun +yas/org-src-lang ()
  "Try to find the current language of the src/header at `point'.
Return nil otherwise."
  (let ((context (org-element-context)))
    (pcase (org-element-type context)
      ('src-block (org-element-property :language context))
      ('inline-src-block (org-element-property :language context))
      ('keyword (when (string-match "^header-args:\\([^ ]+\\)" (org-element-property :value context))
                  (match-string 1 (org-element-property :value context)))))))

(defun +yas/org-last-src-lang ()
  "Return the language of the last src-block, if it exists."
  (save-excursion
    (beginning-of-line)
    (when (re-search-backward "^[ \t]*#\\+begin_src" nil t)
      (org-element-property :language (org-element-context)))))

(defun +yas/org-most-common-no-property-lang ()
  "Find the lang with the most source blocks that has no global header-args, else nil."
  (let (src-langs header-langs)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^[ \t]*#\\+begin_src" nil t)
        (push (+yas/org-src-lang) src-langs))
      (goto-char (point-min))
      (while (re-search-forward "^[ \t]*#\\+property: +header-args" nil t)
        (push (+yas/org-src-lang) header-langs)))

    (setq src-langs
          (mapcar #'car
                  ;; sort alist by frequency (desc.)
                  (sort
                   ;; generate alist with form (value . frequency)
                   (cl-loop for (n . m) in (seq-group-by #'identity src-langs)
                            collect (cons n (length m)))
                   (lambda (a b) (> (cdr a) (cdr b))))))

    (car (cl-set-difference src-langs header-langs :test #'string=))))

(global-aggressive-indent-mode 1)
(add-to-list 'aggressive-indent-excluded-modes 'html-mode)


(add-hook 'org-pomodoro-break-finished-hook 'org-pomodoro-prompt)
(add-hook 'Info-mode-hook #'mixed-pitch-mode)
(global-visual-line-mode t)
(require 'org-roam-protocol)
