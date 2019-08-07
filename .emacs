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

      ;; input & interactionq
      mouse-wheel-scroll-amount '(1 ((shift) . 1)) ;; one line at a time
      mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
      mouse-wheel-follow-mouse 't ;; scroll window under mouse
      scroll-step 1 ;; keyboard scroll one line at a time
      mac-command-modifier 'meta
      ring-bell-function 'ignore ;; no more annoying boop
      vc-follow-symlinks t)

;; use -default when variables are buffer-local 
(setq-default truncate-lines t ;; truncate rather than wrap lines
              auto-fill-function 'do-auto-fill ;; automatically fill lines everywhere
              indent-tabs-mode nil ;; use spaces
              tab-width 4 ;; always 4
              fill-column 79) ;; PEP8 >_<

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

;; I should really think through where I want to put my binaries and get them
;; all in one place...
(add-to-exec-path "/usr/local/bin")
(add-to-exec-path "~/.local/bin")

;;;;;;;;;;;;::;;;;;;;;;;;;;;
;;; GENERAL KEY BINDINGS ;;;
;;;;;;;;;;;;;;::;;;;;;;;;;;;

;; global bindings to comment and uncomment regions
(global-set-key [?\C-x ?\C-/] 'comment-region)
(global-set-key [?\C-x ?\C-.] 'uncomment-region)

;; quick toggle for auto-fill mode, sometimes I don't want it
(global-set-key (kbd "C-c q") 'auto-fill-mode)

;; bind this, cause I use it quite a lot. This overrides mark-page, but I don't
;; use that much, so it's fine.
(global-set-key (kbd "C-x C-p") 'delete-indentation)

;; use regex search by default, but expose non-regex search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; cause I <3 comment boxes
(global-set-key (kbd "C-c b b") 'comment-box)

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
(add-to-list 'package-archives ;; stable versions
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives ;; nightly builds from GitHub
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; It's best to use programmatic package specification so that this file can be
;; easily transferred between machines, and transparently contains all
;; information needed to get emacs running.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Since we have both melpa and melpa-stable in our package-archives, we
;; shouldn't just :ensure these things. Cause then we might get the nightly
;; github builds from melpa, instead of the releases from melpa-stable. So, if
;; you want to install a new package, use package-list-packages to get the
;; version you want manually.

;; alien fruit salad ++
(use-package zenburn-theme
  :init
  (load-theme 'zenburn t))

(use-package diminish
  :init
  (diminish 'auto-fill-function))

;; repo can be found at https://github.com/AndreaCrotti/yasnippet-snippets.git
(use-package yasnippet)

;; We have to add ~/.local/bin to the path so that elpy can see flake8, or any
;; other python-based binaries which are installed via --user.
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
  ;; needs to be an elpy mode hook so that it runs AFTER elpy starts up
  (add-hook 'elpy-mode-hook (lambda () (diminish 'highlight-indentation-mode)))
  :custom
  (elpy-rpc-python-command "~/.pyenv/versions/3.6.8/bin/python")
  (python-shell-interpreter "~/.pyenv/versions/3.6.8/bin/python")
  (elpy-rpc-backend "jedi"))

;; slice-image prevents scrolling issues in EIN. See
;; https://github.com/tkf/emacs-ipython-notebook/issues/94 for more. Also, bind
;; clear all output to C-c C-x C-c. Meant to mirror C-c C-x C-r to restart
;; kernel, and avoids the awkward C-c C-S-l that clear-all-output defaults to.
(use-package ein
  :pin melpa
  :init
  (add-hook 'ein:notebook-mode-hook 'jedi:setup)
  :config
  (add-hook 'find-file-hook ;; open files as ipython notebooks automagically
            (lambda ()
              (when (eq major-mode 'ein:ipynb-mode)
                (call-interactively #'ein:process-find-file-callback))))
  :custom
  (ein:completion-backend 'ein:use-ac-backend) ;; ac-jedi-backend doesn't work
  (ein:complete-on-dot t)
  (ein:truncate-long-cell-output nil)
  (ein:slice-image t)
  :bind
  ("C-c C-x C-c" . ein:worksheet-clear-all-output))

;; I like this for find-file and kill-buffer. It gets trumped by helm in a lot
;; of cases.
(use-package ido
  :init (ido-mode t))

;; I don't use a lot of these keybindings, but I'm going to leave them in here
;; so that I can dig into them later if I get curious.
(use-package helm
  :diminish helm-mode ;; don't show in mode-list
  :init
  (require 'helm-config)
  (setq helm-candidate-number-limit 100)
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
  (setq jedi:complete-on-dot t)
  ;; sometimes jedi isn't on, so make a global kbd for use with elpy and ein
  (global-set-key (kbd "C-x C-j") 'jedi:setup))

(use-package markdown-mode
  :custom (markdown-enable-math t))

(use-package yaml-mode)

;; lololol
(use-package nyan-mode
  :init (add-hook 'find-file-hook 'nyan-mode))

;;;;;;;;;;;;;;;;;;;;
;; LOCAL PACKAGES ;;
;;;;;;;;;;;;;;;;;;;;

;; SQL-PRESTO ;;

;; Fixed some typos and added a couple features relative to the MELPA version.
(add-to-list 'load-path "~/.emacs.d/lisp/sql-prestodb/src/")
(require 'sql-presto)
;; configs to connect to SF's presto server
(setq sql-server "presto.vertigo.stitchfix.com")
(setq sql-database "hive")
;; make it easy to connect a buffer to an interactive presto session
(global-set-key (kbd "C-x M-P") 'sql-presto-scratch)
(define-key sql-mode-map (kbd "M-P") 'sql-prestofy-buffer)
;; we'd like to add a sql-prestofy-buffer hook for sql-mode, but that prevents
;; the initial window from ever opening! How to fix?

;; SPHINX-DOC ;;

;; Included support for type-hints. Do C-c M-d to insert docstrings for
;; functions.
(add-to-list 'load-path "~/.emacs.d/lisp/sphinx-doc.el/")
(require 'sphinx-doc)
(diminish 'sphinx-doc-mode)
(add-hook 'python-mode-hook (lambda () (sphinx-doc-mode t)))
(setq sphinx-doc-all-arguments t)
(setq sphinx-doc-include-types t)

;;;;;;;;;;;;;;
;; ORG MODE ;;
;;;;;;;;;;;;;;

(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

(setq org-log-done t
      org-cycle-separator-lines -1 ;; don't collapse blank lines
      ;; indent rather than showing all the stars
      org-startup-indented t 
      org-agenda-files (list "~/Dropbox/org/work.org"
                             "~/Dropbox/org/home.org"))

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

;; Run/highlight code using babel in org-mode. see dzop/emacs-jupyter for an
;; alternative, maybe more responsive to issues?  Could submit something about
;; image slicing there.
;;
;; Also good to be aware that this slows startup down by a couple seconds.
(use-package ob-ipython
  :init
  ;; Fix an incompatibility between the ob-async and ob-ipython packages
  (setq ob-async-no-async-languages-alist '("ipython"))
  (setq ob-ipython-command "~/.pyenv/shims/ipython"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ipython . t)
   (shell . t)
   (emacs-lisp . t)))

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
 '(org-agenda-files (quote ("~/Dropbox/org/work.org")))
 '(package-selected-packages
   (quote
    (realgud sqlup-mode jupyter ob-sh ob-ipython treemacs treemacs-magit treemacs-projectile blacken-mode nyan-mode yaml-mode which-key use-package smartparens multiple-cursors magit elpy ein))))
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

