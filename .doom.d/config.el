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
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

(delete-selection-mode 1)                             ; Replace selection when inserting text
(display-time-mode 1)                                   ; Enable time in the mode-line
(global-subword-mode 1)                           ; Iterate through CamelCase words
(global-undo-tree-mode)                           ; Vim like undo instead of emacs one
(setq line-spacing 0.3)                                   ; seems like a nice line spacing balance.

(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))
(setq +ivy-buffer-preview t)

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

(setq doom-font (font-spec :family "Terminus" :size 16)
            doom-big-font (font-spec :family "Terminus" :size 36)
            ;doom-variable-pitch-font (font-spec :family "ETBembo" :size 24)
            ;doom-serif-font (font-spec :family "ETBembo" :size 24)
            )

;;light themes
;(setq doom-theme 'doom-gruvbox-light)
;(setq doom-theme 'zaiste)
;(setq doom-theme 'doom-flatwhite)
;;dark themes
(setq doom-theme 'doom-two)

(setq display-line-numbers-type t)

 (defun my-buffer-face-mode-variable ()
   "Set font to a variable width (proportional) fonts in current buffer"
   (interactive)
   (setq buffer-face-mode-face '(:family "Terminus" :height 100 ))
   (buffer-face-mode))
 (add-hook 'org-mode-hook 'my-buffer-face-mode-variable)

(setq org-directory "~/Documents/Estudios/org-notes/")

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
        (setq org-capture-templates
        '(("t" "TODO" entry (file+headline as/gtd "Collect")
        "* TODO %? %^G \n  %U" :empty-lines 1)
        ("s" "Scheduled TODO" entry (file+headline as/gtd "Collect")
        "* TODO %? %^G \nSCHEDULED: %^t\n  %U" :empty-lines 1)
        ("d" "Deadline" entry (file+headline as/gtd "Collect")
            "* TODO %? %^G \n  DEADLINE: %^t" :empty-lines 1)
        ("p" "Priority" entry (file+headline as/gtd "Collect")
        "* TODO [#A] %? %^G \n  SCHEDULED: %^t")
        ("a" "Appointment" entry (file+headline as/gtd "Collect")
        "* %? %^G \n  %^t")
        ("l" "Link" entry (file+headline as/gtd "Collect")
        "* TODO %a %? %^G\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n")
        ("n" "Note" entry (file+headline as/gtd "Notes")
            "* %? %^G\n%U" :empty-lines 1)
        ("j" "Journal" entry (file+datetree "/home/hakuya/Documents/Estudios/org-notes/journal.org")
        "* %? %^G\nEntered on %U\n")))


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
;;      )

(use-package! zotxt
  :after org)
;(add-to-list 'load-path (expand-file-name "ox-pandoc" starter-kit-dir))

(use-package! ox-pandoc
  :after org)
;; default options for all output formats
(setq org-pandoc-options '((standalone . _)))
;; cancel above settings only for 'docx' format
(setq org-pandoc-options-for-docx '((standalone . nil)))
;; special settings for beamer-pdf and latex-pdf exporters
(setq org-pandoc-options-for-beamer-pdf '((pdf-engine . "xelatex")))
(setq org-pandoc-options-for-latex-pdf '((pdf-engine . "pdflatex")))
;; special extensions for markdown_github output
(setq org-pandoc-format-extensions '(markdown_github+pipe_tables+raw_html))

;;(use-package! org-roam-bibtex
;;  :load-path "~/Documents/Estudios/org-notes/references/library.bib" ;Modify with your own path
;;  :hook (org-roam-mode . org-roam-bibtex-mode)
;;  :bind (:map org-mode-map
;;         (("C-c n a" . orb-note-actions))))
(setq orb-templates
      '(("r" "ref" plain (function org-roam-capture--get-point) ""
         :file-name "${citekey}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n" ; <--
         :unnarrowed t)))
(setq orb-preformat-keywords   '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))

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
 )

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

(setq-default history-length 1000) ; remembering history from precedent
(setq-default prescient-history-length 1000)

(use-package! info-colors
  :commands (info-colors-fontify-node))

(use-package! org-pomodoro
  :ensure t
  :commands (org-pomodoro)
  :config
  (setq
   alert-user-configuration (quote ((((:category . "org-pomodoro")) libnotify nil)))
   org-pomodoro-length 50
   org-pomodoro-short-break-length 10
   ))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(add-hook 'Info-mode-hook #'mixed-pitch-mode)

(require 'org-roam-protocol)
