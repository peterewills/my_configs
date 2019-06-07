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


;; get rid of that picture at startup
(setq inhibit-startup-message t)


(setq user-full-name "Peter Wills"
      user-mail-address "peter.wills@stitchfix.com")


;; increase threshold for garbage collection to 50 MB
(setq gc-cons-threshold 50000000)


;; make scratch buffer be text mode instead of lisp-fill
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "###########################################
## Scratch buffer, will not be autosaved ##
###########################################

")


;; add themes in .emacs.d/themes folder to list of themes, set zenburn as the
;; current theme. To get zenburn, do
;;
;;  curl https://raw.githubusercontent.com/bbatsov/zenburn-emacs/master/zenburn-theme.el \
;;    > ~/.emacs.d/themes/zenburn-theme.el
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)


;; set default font
(add-to-list 'default-frame-alist '(font . "Menlo-14" ))
(set-face-attribute 'default t :font "Menlo-14" )


;; put backup files in the temporary-file-directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; truncate rather than wrap lines
(set-default 'truncate-lines t)


;; highlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#000")


;; save your place
(save-place-mode 1)


;; bind cmd key to meta
(setq mac-command-modifier 'meta)


;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time


;; kill toolbar
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))


;; automatically fill lines everywhere
(setq-default auto-fill-function 'do-auto-fill)


;; change default tab spacing, and make sure to always use spaces
(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 79)

(show-paren-mode 1)
(electric-pair-mode 1)
;; don't pair single or double quotes. It doesn't work well in elpy.
(setq electric-pair-inhibit-predicate
      (lambda (c)
        (if (or (char-equal c ?\") (char-equal c ?\'))
            t (electric-pair-default-inhibit c))))


;;;;;;;;;;;;::;;;;;;;;;;;;;;
;;; GENERAL KEY BINDINGS ;;;
;;;;;;;;;;;;;;::;;;;;;;;;;;;


;; global bindings to comment and uncomment regions
(global-set-key [?\C-x ?\C-/] 'comment-region)
(global-set-key [?\C-x ?\C-.] 'uncomment-region)

;; quick toggle for auto-fill mode, sometimes I don't want it
(global-set-key (kbd "C-c q") 'auto-fill-mode)

;; I don't use C-b to to navigate text, so reset it to delete-indentation,
;; which I use a fair bit
(global-set-key (kbd "C-b") 'delete-indentation)

;; use regex search by default, but expose non-regex search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; cause I <3 comment boxes
(global-set-key (kbd "C-c b b") 'comment-box)


;;;;;;;;;;;;;;
;; PACKAGES ;;
;;;;;;;;;;;;;;


;; enable installation of packages from MELPA
(require 'package) 
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives
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

;; always install packages if they are not present. This means we don't have to
;; add :ensure t to every use-package declaration
(require 'use-package-ensure)
(setq use-package-always-ensure t)


;; repo can be found at https://github.com/AndreaCrotti/yasnippet-snippets.git
(use-package yasnippet
  :custom
  (yas-snippet-dirs '("/Users/peterwills/.emacs.d/yasnippet-snippets/")))

;; auto-completion for python
(use-package jedi
  :init (setq jedi:complete-on-dot t))

;; We have to add ~/.local/bin to the path so that elpy can see flake8, which
;; we installed just for the user. Why did we do that? Well, I forget.
;;
;; For a fresh installation, you'll want to
;;
;;   pip install flake8 jedi rope autopep8 black yapf.
;;
;; This should get you full Elpy bells & whistles. Maybe install --user?
(use-package elpy
  :init
  (elpy-enable)
  (setenv "PATH" (concat (getenv "PATH") ":~/.local/bin"))
  (setq exec-path (append exec-path '("~/.local/bin")))
  (setenv "PATH" (concat (getenv "PATH") ":~/.pyenv/shims")) ;; pyenv pip installs stuff here
  (setq exec-path (append exec-path '("~/.pyenv/shims")))
  (add-hook 'python-mode-hook (company-mode -1)) ;; this interferes with jedi
  (add-hook 'python-mode-hook #'jedi:setup)
  :custom
  (elpy-rpc-python-command
   "/Users/peterwills/.pyenv/versions/3.6.8/bin/python")
  (python-shell-interpreter
   "/Users/peterwills/.pyenv/versions/3.6.8/bin/python")
  (elpy-rpc-backend "jedi"))

;; slice-image prevents scrolling issues in EIN. See
;; https://github.com/tkf/emacs-ipython-notebook/issues/94 for more. Also, bind
;; clear all output to C-c C-x C-c. Meant to mirror C-c C-x C-r to restart
;; kernel, and avoids the awkward C-c C-S-l that clear-all-output defaults to.
;;
;; I'd like to be able to use Jedi with EIN, but it doesn't seem to work. I
;; think I'm using the right hook, and using #'jedi:setup works for elpy, and
;; if I do M-x jedi:setup then it works in EIN... but adding the hook below
;; doesn't get it going at startup.
(use-package ein
  :pin melpa
  :init
  (add-hook 'ein:connect-mode-hook #'jedi:setup)
  :custom
  (ein:completion-backend 'ein:use-ac-backend) ;; I'd prefer jedi...
  (ein:truncate-long-cell-output nil)
  (ein:slice-image t)
  :bind
  ("C-c C-x C-c" . ein:worksheet-clear-all-output))

;; I like this for find-file and kill-buffer.
(use-package ido
  :init (ido-mode t))

(use-package helm
  :diminish helm-mode
  :init
  (require 'helm-config)
  (setq helm-candidate-number-limit 100)
  (helm-mode)
  :bind (("C-c h" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-b" . helm-buffers-list)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-x c s" . helm-swoop)
         ("C-x c y" . helm-yas-complete)
         ("C-x c Y" . helm-yas-create-snippet-on-region)
         ("C-x c b" . my/helm-do-grep-book-notes)
         ("C-x c SPC" . helm-all-mark-rings)
         ("C-x C-f" . helm-find-files)
         ;; ("TAB" . helm-execute-persistent-action) ;; should give tab completion, but doesn't :(
         ))

;; allows project-wide search & replace
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
  :init (which-key-mode))

;; enable auto complete
(use-package auto-complete
  :init (global-auto-complete-mode t)) 

(use-package markdown-mode
  :custom (markdown-enable-math t))

(use-package yaml-mode)

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
 '(package-selected-packages
   (quote
    (yaml-mode which-key use-package smartparens multiple-cursors magit elpy ein))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
