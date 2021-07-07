;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here, run 'doom sync' on
;; the command line, then restart Emacs for the changes to take effect.
;; Alternatively, use M-x doom/reload.


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a particular repo, you'll need to specify
;; a `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, for whatever reason,
;; you can do so here with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))


;(package! org-ref)
;(package! interleave)                                        not using anymore as org-noter is far superior.
;(package! helm-bibtex)
;(package! zotxt)
(package! ox-gfm :pin "99f93011b069e02b37c9660b8fcb45dab086a07f")
(package! ox-pandoc)
;(package! org-roam-bibtex)
(package! org-noter)
(package! org-roam-server :recipe (:host github :repo "org-roam/org-roam-server" :files ("*")))
(unpin! org-roam)
(package! org-download)
;(package! nov)                                             not using anymore as epub note taking is annoying in nov.el (package! rotate) (package! xkcd)
(package! keycast)
(package! org-super-agenda)
(package! doct
  :recipe (:host github :repo "progfolio/doct"))
(package! org-pretty-table-mode
  :recipe (:host github :repo "Fuco1/org-pretty-table"))
(package! org-pretty-tags)
;(package! centaur-tabs)
(package! company-org-roam :recipe (:host github :repo "org-roam/company-org-roam"))
(package! org-fancy-priorities)
(package! origami)
;(package! org-journal)     ;DOOM has org-journal built in, enable using +journal flag in init.el
(package! info-colors ) ; pretty colors
(package! beacon) ; global minor mode for a blinking highliter to find where the cursor is.
(package! org-xournalpp
  :recipe (:host gitlab
           :repo "vherrmann/org-xournalpp"
           :files ("resources" "*.el")))
(package! impatient-mode)
(package! emmet-mode)
(package! prettier)
(package! org-pretty-table
  :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "87772a9469d91770f87bfa788580fca69b9e697a")
(package! org-pretty-tags :pin "5c7521651b35ae9a7d3add4a66ae8cc176ae1c76")
(package! org-ol-tree :recipe (:host github :repo "Townk/org-ol-tree")
  :pin "207c748aa5fea8626be619e8c55bdb1c16118c25")
(package! aggressive-indent)
