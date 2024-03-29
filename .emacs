;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; PETER'S .emacs! ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


(setq
 ;;startup
 inhibit-startup-message t ;; get rid of that picture at startup
 inhibit-startup-echo-area-message t
 initial-scratch-message nil
 initial-major-mode 'fundamental-mode

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
 pixel-scroll-mode t

 ;; exiting emacs
 confirm-kill-emacs 'yes-or-no-p
 confirm-kill-processes nil

 ;; don't save custom variables
 custom-file (make-temp-file "emacs-custom"))

;; use -default when variables are buffer-local
(setq-default truncate-lines t ;; truncate rather than wrap lines
              auto-fill-function 'do-auto-fill ;; automatically fill lines everywhere
              indent-tabs-mode nil ;; use spaces
              fill-column 88) ;; PEP8 >_<

;; Default shell in term
(setq-default shell-file-name "/bin/bash")
(setq explicit-shell-file-name "/bin/bash")

;; always do y-or-n
(fset 'yes-or-no-p 'y-or-n-p)

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
(add-to-exec-path "/Users/peterewills/.local/bin")
(add-to-exec-path "/opt/homebrew/bin")
(add-to-exec-path "/Users/peterewills/code/source/.venv/bin/")

(add-to-exec-path "/Users/peterewills/.flake8_venv/bin")
;; we prefix this to the path to guarantee that the python that gets used is the one
;; defined by pyenv, not /usr/bin/python
;; (prefix-to-exec-path "/Users/peterewills/.pyenv/shims")

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

;; cause I <3 comment boxes
(global-set-key (kbd "C-c c b") 'comment-box)

;; I want these to work both in python mode and in EIN, so I'll just set them as
;; global. This way they can even work in org code snippets, or markdown, or whatever
(global-set-key (kbd "C-c b b") 'python-black-buffer)
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

;; smerge - turn on smerge automatically on files with conflicts. Simplify the
;; keybindings.

(defun sm-try-smerge ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil t)
      (smerge-mode 1))))

(add-hook 'find-file-hook 'sm-try-smerge t)
(add-hook 'smerge-mode-hook
      (lambda ()
        (local-set-key (kbd "M-RET") #'smerge-keep-current)
        (local-set-key (kbd "M-a") #'smerge-keep-all)
        (local-set-key (kbd "M-u") #'smerge-keep-upper)
        (local-set-key (kbd "M-l") #'smerge-keep-lower)
        (local-set-key (kbd "M-n") #'smerge-next)
        (local-set-key (kbd "M-p") #'smerge-prev)))

;;;;;;;;;;;;;;;;
;; APPEARANCE ;;
;;;;;;;;;;;;;;;;

;; window should fill half the screen width-wise, and be full-height
(setq default-frame-alist
       '((height . 1.0)
         (width . 0.5)
         (left . 0)
         (top . 0)
         ;; some configs that are available, but I don't use
         ;; (vertical-scroll-bars . nil)
         ;; (horizontal-scroll-bars . nil)
         ;; (tool-bar-lines . 0)
         ))

;; highlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#393939")

;; I'd prefer to have the weight be light, but then the bold stuff really looks
;; ridiculous next to it. So, the question is, how can I set the default weight to light
;; and the bold stuff to medium weight? That would be optimal.
(set-face-attribute 'default nil
                    :height 145
                    :family "Fira Code Light"
                    :weight 'medium)
;;;;;;;;;;;;;;
;; PACKAGES ;;
;;;;;;;;;;;;;;

(require 'package)
;; If you have trouble finding a package on Melpa, then maybe you need to refresh your
;; package-list-packages buffer.
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
  (add-hook 'elpy-mode-hook (lambda () (diminish 'highlight-indentation-mode)))
  (add-hook 'elpy-mode-hook (lambda () (hs-minor-mode)))
  ;; turn off auto-fill-mode in python environments - it ends up doing syntactically
  ;; invalid wrapping. Just use C-c C-c b to blacken the whole buffer if you want to
  ;; "wrap". For comments you can use M-q as usual.
  (add-hook 'python-mode-hook (lambda () (auto-fill-mode -1)))
  (add-hook 'python-mode-hook (lambda () (sphinx-doc-mode)))
  :custom
  (elpy-rpc-backend "jedi")
  (elpy-rpc-python-command "/opt/homebrew/bin/python3.8")
  (python-shell-interpreter "/opt/homebrew/bin/python3.8")
  (elpy-rpc-virtualenv-path 'default))

(use-package python-black
  :demand t
  :after python)

(use-package py-isort
  :after python)

(use-package sphinx-doc
  :after python)

;; a requirement for python-pytest, doesn't get installed by default for some reason
(use-package dash-functional)
(use-package python-pytest)

;; EIN, build from local with some updates/fixes/etc.
;;
;; Leave the package-generate-autoloads call commented out unless you're acitvely
;; working on the code.
(use-package ein
  :ensure nil
  :init
  (add-hook 'ein:notebook-mode-hook 'jedi:setup)
  (package-generate-autoloads "ein" "/Users/peter.wills@equipmentshare.com/.emacs.d/lisp/emacs-ipython-notebook/lisp/")
  (load-file "/Users/peter.wills@equipmentshare.com/.emacs.d/lisp/emacs-ipython-notebook/lisp/ein-autoloads.el")
  :config
  ;; open files as ipython notebooks automagically
  (add-hook 'ein:ipynb-mode-hook 'ein:maybe-open-file-as-notebook)
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
  ("C-c C-x C-f" . ein:new-notebook)
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
  ;; (require 'helm-config)
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
  ;; When I implement projectile-global-mode then in elpy "p" gets bound to the
  ;; projectile-command-map, which obviously is annoying since that means I can't type
  ;; the letter p. I should try and figure out how to undo that binding; without
  ;; projectile-global-mode I can't do projectile-find-file.
  :init
  (projectile-mode)
  ;; Useful Commands:
  ;;    C-c p s g  Run grep on the files in the project.
  ;;    C-c p r  Runs interactive query-replace on all files in the projects.
  ;;    C-c p C-h (shows all projectile bindings)
  :bind-keymap ("C-c p" . projectile-command-map)
  ;; just so I can turn off projectile mode if it gets buggy. TODO remove this once
  ;; things work nicely
  :bind ("C-c C-q" . projectile-mode)
  :config
  (setq projectile-enable-caching t)
  (setq projectile-switch-project-action 'projectile-dired))

(use-package helm-rg)

(use-package helm-projectile
  :bind
  ;; replace projectile's default grepping and find-file with helm-projectile variants,
  ;; which are much more useful.
  (:map projectile-command-map
        ("f" . helm-projectile-find-file)
        ("s g" . helm-projectile-rg)))


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
  (setq ac-use-comphist nil) ;; turn off history since it's brutally slow on kill
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

(use-package thrift
  :custom (thrift-indent-level 4))

(use-package yaml-mode)

;; lololol
(use-package nyan-mode
  :init (add-hook 'find-file-hook 'nyan-mode))

;;;;;;;;;;;;;;
;; ORG MODE ;;
;;;;;;;;;;;;;;

;; this stuff might be out of date, especially the tex preview stuff - haven't played
;; with that in quite some time.

(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

(setq org-log-done t
      org-cycle-separator-lines -1 ;; don't collapse blank lines
      ;; indent rather than showing all the stars
      org-startup-indented t
      org-hide-emphasis-markers t ;; don't show stars for bold, or whatever.
      org-agenda-files (list "/Users/peterewills/org/work.org")
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

;; If I get excited about code execution in org mode anytime soon, just use the kernel
;; from EIN (it lets you connect to notebook kernels, or run an "anonymous" kernel).

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   (emacs-lisp . t)))

(defun org-insert-sql-block ()
  "Insert a code block for sql."
  (interactive)
  (insert "#+BEGIN_SRC sql

#+END_SRC")
  (forward-line -2)
  (goto-char (line-end-position)))

(define-key org-mode-map (kbd "C-c i s") 'org-insert-sql-block)

;; Syntax highlight in #+BEGIN_SRC blocks
(setq org-src-fontify-natively t)
;; Don't prompt before running code in org
(setq org-confirm-babel-evaluate nil)

(diminish 'org-indent-mode)

;;;;;;;;;;;;;
;; STARTUP ;;
;;;;;;;;;;;;;

(load "~/secrets") ;; passwords can be stored in this file
;; activate our sandbox venv by default
(pyvenv-activate "/Users/peter.wills@equipmentshare.com/code/sandbox")
