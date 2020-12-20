;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; PETER'S .emacs! ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Credit to the better-defaults package, various stack exchange articles, and Sandeep Nambiar:
;;
;;  https://www.sandeepnambiar.com/my-minimal-emacs-setup/


;;;;;;;;;;;;;;;;;;;;
;; ZENBURN COLORS ;;
;;;;;;;;;;;;;;;;;;;;


;; Gray: #3F3F3F
;; Light Gray: #6F6F6F
;; White: #FFFFEF
;; Red: #CC9393
;; Green: #7F9F7F
;; Orange: #DFAF8F
;; Yellow: #F0DFAF
;; Cyan: #93E0E3
;; Blue: #8CD0D3
;; Dark Red: #A55D5D
;; Dark Green: #466F46
;; Dark Blue: #4A7274
;; Dark Orange: #A352E


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STARTUP CONFIGURATION ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq inhibit-startup-message t ;; get rid of that picture at startup

      ;; performance
      gc-cons-threshold 50000000 ;; higher GC threshold, since I have plenty of RAM
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      load-prefer-newer t ;; recompile if byte-compiled file is out of date

      ;; input & interactionq
      mouse-wheel-scroll-amount '(1 ((shift) . 1)) ;; one line at a time
      mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
      mouse-wheel-follow-mouse 't ;; scroll window under mouse
      scroll-step 1 ;; keyboard scroll one line at a time
      mac-command-modifier 'meta
      ring-bell-function 'ignore ;; no more annoying boop
      vc-follow-symlinks t

      ;; exiting emacs
      confirm-kill-emacs 'yes-or-no-p
      confirm-kill-processes nil)

;; use -default when variables are buffer-local
(setq-default truncate-lines t ;; truncate rather than wrap lines
              auto-fill-function 'do-auto-fill ;; automatically fill lines everywhere
              indent-tabs-mode nil ;; use spaces
              tab-width 4 ;; always 4
              fill-column 88) ;; PEP8 >_<

;; window should fill half the screen width-wise, and be full-height
(add-to-list 'default-frame-alist '(width . 0.5))
(add-to-list 'default-frame-alist '(height . 1.0))

;; set default font
(add-to-list 'default-frame-alist '(font . "Menlo-14" ))
(set-face-attribute 'default t :font "Menlo-14" )

;; highlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#000")

;; save your place
(save-place-mode 1)

;; kill trailing whitespace on save
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; kill toolbar
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(show-paren-mode 1)

;; Still can't decide if I actually want this or not - it's honestly kind of
;; annoying sometimes.
(electric-pair-mode 1)

;; don't pair single or double quotes. It doesn't work well in elpy.
(setq electric-pair-inhibit-predicate
      (lambda (c)
        (if (or (char-equal c ?\") (char-equal c ?\'))
            t (electric-pair-default-inhibit c))))

(defun add-to-exec-path (path)
  "Add a path to both exec-path and environment variable PATH"
  (setenv "PATH" (concat (getenv "PATH") (concat ":" path)))
  (setq exec-path (append exec-path (cons path nil))))


(defun prefix-to-exec-path (path)
  "Add a path to both exec-path and environment variable PATH"
  (setenv "PATH" (concat (concat path ":") (getenv "PATH")))
  (setq exec-path (cons path exec-path)))

;; I should really think through where I want to put my binaries and get them
;; all in one place...
(add-to-exec-path "/usr/local/bin")
(add-to-exec-path "~/.local/bin")
;; we prefix this to the path to guarantee that the python that gets used is the one
;; defined by pyenv, not /usr/bin/python
(prefix-to-exec-path "~/.pyenv/shims")

;;;;;;;;;;;;::;;;;;;;;;;;;;;
;;; GENERAL KEY BINDINGS ;;;
;;;;;;;;;;;;;;::;;;;;;;;;;;;

;; global bindings to comment and uncomment regions
(global-set-key [?\C-x ?\C-/] 'comment-region)
(global-set-key [?\C-x ?\C-.] 'uncomment-region)

;; quick toggle for auto-fill mode, sometimes I don't want it
(global-set-key (kbd "C-c q") 'auto-fill-mode)
(global-set-key (kbd "C-c e") 'electric-pair-mode)

;; I use this one so much that I wanted to make it easier
(global-set-key (kbd "C-o") 'other-window)

;; bind this, cause I use it quite a lot. This overrides mark-page, but I don't
;; use that much, so it's fine.
(global-set-key (kbd "C-x C-p") 'delete-indentation)

;; use regex search by default, but expose non-regex search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; hideshow mode, rebind map to C-c h. Hiding levels still doesn't do quite what I want,
;; but I'm working on it :)
(defun hs-hide-n-levels ()
  "Interacitve hide-levels, prompting the user for number of
levels to hide."
  (interactive)
  (hs-hide-level
   (string-to-number
    (read-string "Enter levels to hide: "))))

(global-set-key (kbd "C-<tab>") 'hs-toggle-hiding)
(global-set-key (kbd "C-c h b") 'hs-hide-block)
(global-set-key (kbd "C-c h s") 'hs-show-block)
(global-set-key (kbd "C-c h h") 'hs-hide-all)
(global-set-key (kbd "C-c h a") 'hs-show-all)
(global-set-key (kbd "C-c h n") 'hs-hide-n-levels)
(global-set-key (kbd "C-c h 1") (lambda () (interactive) (hs-hide-level 1)))
(global-set-key (kbd "C-c h 2") (lambda () (interactive) (hs-hide-level 2)))
(global-set-key (kbd "C-c h 3") (lambda () (interactive) (hs-hide-level 3)))


;; cause I <3 comment boxes
(global-set-key (kbd "C-c c b") 'comment-box)

;; I want these to work both in python mode and in EIN, so I'll just set them as
;; global. This way they can even work in org code snippets, or markdown, or whatever
(global-set-key (kbd "C-c b b") 'python-black)
(global-set-key (kbd "C-c b r") 'python-black-region)

;; configure elisp mode
(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-buffer)

;; dired - use C-j and C-l to go down and up the filetree, mimicing helm. Don't
;; pop open new buffers when you do this - use dired-find-alternate-file
;; instead of dired-find-file.
(eval-after-load "dired"
  '(progn
     (add-hook 'dired-mode-hook
               (lambda ()
                 (define-key dired-mode-map (kbd "C-l")
                  (lambda () (interactive) (find-alternate-file "..")))))
     (put 'dired-find-alternate-file 'disabled nil)
     (define-key dired-mode-map (kbd "C-j") 'dired-find-alternate-file)
     (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
     (setq dired-listing-switches "-alFh")))

;;;;;;;;;;;;;;
;; PACKAGES ;;
;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives ;; nightly builds from GitHub
             '("melpa" . "https://melpa.org/packages/"))
;; (add-to-list 'package-archives ;; "stable" versions - sometimes not actually updated
;;              '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; It's best to use programmatic package specification so that this file can be
;; easily transferred between machines, and transparently contains all
;; information needed to get emacs running.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; always install packages if they are not present. This means we don't have to
;; add :ensure t to every use-package declaration. Use stable versions by default
(require 'use-package-ensure)
(setq use-package-always-ensure t)
;; we pin to melpa by default since melpa-stable isn't always stable/reliable. If you
;; start with an empty .emacs.d, then you'll load the latest version of packages, and
;; things might break. Too bad you can't pin to certain versions.
(setq use-package-always-pin "melpa")

;; Since we have both melpa and melpa-stable in our package-archives, we
;; shouldn't just :ensure these things. Cause then we might get the nightly
;; github builds from melpa, instead of the releases from melpa-stable. So, if
;; you want to install a new package, use package-list-packages to get the
;; version you want manually.

;; alien fruit salad ++
(use-package zenburn-theme
  :init
  (load-theme 'zenburn t)
  (set-face-attribute 'region nil :background "#6F6F6F"))

(use-package diminish
  :init
  (diminish 'auto-fill-function))

(use-package expand-region
  :bind
  ("C-=" . er/expand-region)
  ("C--" . er/contract-region))

;; repo can be found at https://github.com/AndreaCrotti/yasnippet-snippets.git
(use-package yasnippet)

;; We have to add ~/.local/bin to the path so that elpy can see flake8, or any
;; other python-based binaries which are installed via --user.

;; In our .emacs.d/lisp directory we have local clone of a fork, which I initially made
;; in order to mess around more with folding. I never put in the time to really get it
;; working smoothly; maybe just try using hideshow mode? It's been a while since I
;; messed with this.
;;
;; For a fresh installation, you'll want to
;;
;;   pip install flake8 jedi autopep8 yapf
;;
;; This should get you full Elpy bells & whistles.
(use-package elpy
  :init
  (elpy-enable)
  (add-to-exec-path "~/.pyenv/shims")
  (add-hook 'elpy-mode-hook (lambda () (diminish 'highlight-indentation-mode)))
  (add-hook 'elpy-mode-hook (lambda () (hs-minor-mode)))
  ;; turn off auto-fill-mode in python environments - it ends up doing syntactically
  ;; invalid wrapping. Just use C-c C-c b to blacken the whole buffer if you want to
  ;; "wrap". For comments you can use M-q as usual.
  (add-hook 'python-mode-hook (lambda () (auto-fill-mode -1)))
  :custom
  (elpy-rpc-python-command "~/.pyenv/versions/3.7.8/bin/python")
  (python-shell-interpreter "~/.pyenv/versions/3.7.8/bin/python")
  (elpy-rpc-backend "jedi"))

(use-package python-black
  :demand t
  :after python)

(use-package py-isort
  :after python)

;; a requirement for python-pytest, doesn't get installed by default for some reason
(use-package dash-functional)
(use-package python-pytest)

;; EIN, build from local with some updates/fixes/etc.
;;
;; I tried cloning the github repo and then putting emacs-ipython-notebook/lisp (the
;; directory containing the source .el files) into my load-path, but it didn't
;; work. This is because package-initialize does some autoloading magics that I don't
;; fully grok, which allows the ein:* commands to be autoloaded and available. I don't
;; really understand what's going on here.
;;
;; So, what I've done is copied the code in .emacs.d/elpa/ein.VERSION into a peter_dev
;; version directory, and then hacked directly on that. I keep this directory under
;; version control:
;;
;; https://github.com/peterewills/emacs-ipython-notebook
;;
;; and stick it in my .emacs.d/lisp directory under the directory name
;; ein-20200806.1552-peter.dev. I'm not sure if that directory name matters, probably
;; not, but at this point I'm like who knows.
;;
;; Since this is still seen in the elpa/ directory, it automatically gets picked up by
;; use-package. But, (I think) it won't get auto-updated, or overwritten, since I set
;; :ensure to nil. Yes, this is hacky.
;;
;; Since I don't understand how loading happens, it makes it hard for me to do custom
;; hacking. I get around this by having an ein-custom.el and specifically requiring it.
;;
;; TODO investigate using quelpa: https://github.com/quelpa/quelpa
(use-package ein
  ;; :pin melpa
  :ensure nil
  :init
  (add-hook 'ein:notebook-mode-hook 'jedi:setup)
  (require 'ein-custom) ;; load custom functions etc
  :config
  ;; open files as ipython notebooks automagically
  (add-hook 'find-file-hook 'ein:maybe-open-file-as-notebook)
  :custom
  (ein:completion-backend 'ein:use-ac-backend) ;; ac-jedi-backend doesn't work
  (ein:complete-on-dot t)
  (ein:truncate-long-cell-output nil)
  (ein:auto-save-on-execute t)
  (ein:auto-black-on-execute t)
  (ein:output-area-inlined-images t)
  (ein:slice-image t)
  (ein:urls "8888")
  :bind
  ("C-x M-w" . ein:notebook-save-to-command)
  ("C-c C-x C-c" . ein:worksheet-clear-all-output)
  ("C-c C-x C-k" . ein:nuke-and-pave)
  ("C-c C-x C-f" . ein:notebook-new-simple)
  ("C-c b c" . ein:worksheet-python-black-cell))

;; I like this for find-file and kill-buffer. It gets trumped by helm in a lot
;; of cases.
(use-package ido
  :init (ido-mode t))

;; this is why emacs will win the editor wars
(use-package fireplace)

(use-package helm
  :diminish helm-mode ;; don't show in mode-list
  :init
  (require 'helm-config)
  (setq helm-candidate-number-limit 100
        helm-buffer-max-length nil)
  (helm-mode)
  :bind (("C-x C-b" . helm-buffers-list)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)))

;; Project-wide search & replace
(use-package projectile
  ;; Useful Commands:
  ;;    C-c p s g  Run grep on the files in the project.
  ;;    C-c p r  Runs interactive query-replace on all files in the projects.
  ;;    C-c p C-h (shows all projectile bindings)
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (setq projectile-enable-caching t)
  (setq projectile-switch-project-action 'projectile-dired))


;; Allows multiple cursors. Highlight region, then use C-S-c C-S-c.
(use-package multiple-cursors
  :bind ("C-S-c C-S-c" . mc/edit-lines))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package which-key
  :diminish which-key-mode
  :init (which-key-mode))

;; enable auto complete
(use-package auto-complete
  :diminish auto-complete-mode
  :init
  (ac-config-default)
  (global-auto-complete-mode t)
  ;; no company in elpy
  (add-hook 'elpy-mode-hook (lambda () (company-mode -1))))

;; auto-completion for python
(use-package jedi
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup)
  (setq jedi:complete-on-dot nil)
  ;; make a global kbd for use with elpy and ein to make sure jedi is on
  (global-set-key (kbd "C-x C-j") 'jedi:setup))

(use-package markdown-mode
  :custom (markdown-enable-math t))

(use-package yaml-mode)

;; lololol
(use-package nyan-mode
  :init (add-hook 'find-file-hook 'nyan-mode))

;; github-flavored markdown previews using C-c C-c g
(use-package grip-mode
  :ensure t
  :bind (:map markdown-mode-command-map
         ("g" . grip-mode)))

;;;;;;;;;;;;;;;;;;;;
;; LOCAL PACKAGES ;;
;;;;;;;;;;;;;;;;;;;;

;; SQL-PRESTO ;;
;;
;; had some trouble getting this to play nice with use-package and local-path. Oh well.
;;
;; Fixed some typos and added a couple features relative to the MELPA version. This
;; breaks in Emacs 27.1 - see comments in the code.
(add-to-list 'load-path "~/.emacs.d/lisp/sql-prestodb/src/")
(require 'sql-presto)
;; configs to connect to SF's presto server
(setq sql-server "http://presto.vertigo.stitchfix.com:8889")
(setq sql-database "hive")
;; run presto via this special SF thing to work with Presto-Guard
(setq sql-presto-program "/Users/peterwills/jars/sf-presto-cli-318-executable.jar")
;; make it easy to connect a buffer to an interactive presto session
(global-set-key (kbd "C-x M-P") 'sql-presto-scratch)
(define-key sql-mode-map (kbd "M-P") 'sql-prestofy-buffer)
;; we'd like to add a sql-prestofy-buffer hook for sql-mode, but that prevents
;; the initial window from ever opening! How to fix?

;; SPHINX-DOC ;;

;; Included support for type-hints. Do C-c M-d to insert docstrings for
;; functions.
(use-package sphinx-doc
  :ensure nil
  :load-path "~/.emacs.d/lisp/sphinx-doc.el/"
  :init
  (diminish 'sphinx-doc-mode)
  (add-hook 'python-mode-hook (lambda () (sphinx-doc-mode t)))
  :custom
  (sphinx-doc-all-arguments t)
  (sphinx-doc-include-types nil))

;; OX-JEKYLL-LITE ;;

;; markdown exporter for org mode that plays nice with jekyll
(use-package ox-jekyll-lite
  :ensure nil
  :load-path "~/.emacs.d/lisp/ox-jekyll-lite/"
  :custom
  (org-jekyll-project-root "~/code/jekyll/peterewills.github.io"))

;;;;;;;;;;;;;;
;; ORG MODE ;;
;;;;;;;;;;;;;;

(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

(setq org-log-done t
      org-cycle-separator-lines -1 ;; don't collapse blank lines
      ;; indent rather than showing all the stars
      org-startup-indented t
      org-hide-emphasis-markers t ;; don't show stars for bold, or whatever.
      org-agenda-files (list "~/Dropbox/org/work.org"
                             "~/Dropbox/org/home.org")
      org-image-actual-width nil ;; allow images to be resize
      )

;; we want tex in our org stuffs! and it needs to not be tiny.
(add-to-exec-path "/Library/TeX/texbin")

(defun org-preview-all-latex-fragments ()
  "Preview all latex fragments in a buffer."
  (interactive)
  (org-preview-latex-fragment 16))

(defun org-increase-latex-preview-scale (scale)
  "Rescale latex previews in a buffer. The usual scaling is tiny."
  (interactive "nScale latex previews to: ")
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale scale)))

;; neither of these work. I think the org-mode-hook runs too early, or
;; something like that.
(add-hook 'org-mode-hook 'org-preview-all-latex-fragments)
(add-hook 'org-mode-hook (lambda () (org-increase-latex-preview-scale 1.5)))


;; Somehow I can't get this to work. I manually copied the ob-ipython to .emacs.d/elpa
;; and it still doesn't like it.
;;
;; If I get excited about code execution in org mode anytime soon, just install
;; emacs-jupyter (just called 'jupyter' in MELPA) and use that instead.

;; ;; Run/highlight code using babel in org-mode. see dzop/emacs-jupyter for an
;; ;; alternative, maybe more responsive to issues?  Could submit something about
;; ;; image slicing there.
;; ;;
;; ;; Also good to be aware that this slows startup down by a couple seconds.
;; (use-package ob-ipython
;;   :init
;;   ;; Fix an incompatibility between the ob-async and ob-ipython packages
;;   (setq ob-async-no-async-languages-alist '("ipython"))
;;   (setq ob-ipython-command "~/.pyenv/shims/ipython"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
;;   (ipython . t)
   (shell . t)
   (emacs-lisp . t)))

(defun org-insert-sql-block ()
  "Insert a code block for sql."
  (interactive)
  (insert "#+BEGIN_SRC sql

#+END_SRC")
  (forward-line -2)
  (goto-char (line-end-position)))

(defun org-insert-ipython-block ()
  "Insert a code block for ipython, which uses the default session, and outputs
  the results to a drawer for inline plotting."
  (interactive)
  (insert "#+BEGIN_SRC ipython :async t :results drawer :session

#+END_SRC")
  (forward-line -2)
  (goto-char (line-end-position)))

(defun org-insert-ipython-imports-block ()
  "Insert the usual imports, so that we don't have to type them over and over"
  (interactive)
  (insert "#+BEGIN_SRC ipython :session
  import numpy as np
  import pandas as pd
  from matplotlib import pyplot as plt
  %matplotlib inline
#+END_SRC")
  (forward-line -2)
  (goto-char (line-end-position)))

(define-key org-mode-map (kbd "C-c i p") 'org-insert-ipython-block)
(define-key org-mode-map (kbd "C-c i s") 'org-insert-sql-block)
(define-key org-mode-map (kbd "C-c i i") 'org-insert-ipython-imports-block)

;; Syntax highlight in #+BEGIN_SRC blocks
(setq org-src-fontify-natively t)
;; Don't prompt before running code in org
(setq org-confirm-babel-evaluate nil)

(diminish 'org-indent-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This is set when you use the customize-variable interface
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("1eb9aac16922091cdb1fb0d2d25fa916b51a29f7006276f4133ce720b7f315e7" default)))
 '(ein:truncate-long-cell-output nil nil nil "Customized with use-package ein")
 '(package-selected-packages
   (quote
    (fireplace py-isort super-save expand-region pandoc-mode magit python-black python-pytest dash-functional zenburn-theme yaml-mode which-key use-package treemacs-projectile treemacs-magit treemacs-icons-dired treemacs-evil sqlup-mode realgud nyan-mode multiple-cursors magit-popup jupyter jedi htmlize helm grip-mode graphql forge ein diminish company-jedi blacken all-the-icons-dired))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OPEN MY ORG FILE AT STARTUP ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(find-file "~/Dropbox/org/work.org")
(save-place-local-mode -1)
