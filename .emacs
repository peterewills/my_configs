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


(setq user-full-name "Peter Wills"
      user-mail-address "peter.wills@stitchfix.com" inhibit-startup-message t ;; get rid of that picture at startup
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
      vc-follow-symlinks t)

;; use -default when variables are buffer-local 
(setq-default truncate-lines t ;; truncate rather than wrap lines
              auto-fill-function 'do-auto-fill ;; automatically fill lines everywhere
              indent-tabs-mode nil ;; use spaces
              tab-width 4 ;; always 4
              fill-column 79) ;; PEP8 >_<  


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

;; highlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#000")

;; save your place
(save-place-mode 1)

;; kill toolbar
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; automatically fill lines everywhere
(setq-default auto-fill-function 'do-auto-fill)

;; change default tab spacing, and make sure to always use spaces. need to use
;; -default since these variables are buffer-local
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

(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-buffer)

;;;;;;;;;;;;;;
;; PACKAGES ;;
;;;;;;;;;;;;;;

(require 'package) 
(add-to-list 'package-archives ;; stable versions
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives ;; nightly builds from GitHub
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(defun add-to-exec-path (path)
  ;; add a path to both exec-path and environment variable PATH
  (setenv "PATH" (concat (getenv "PATH") (concat ":" path)))
  (setq exec-path (append exec-path (cons path nil))))

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

(use-package diminish
  :init
  (diminish 'auto-fill-function))

;; repo can be found at https://github.com/AndreaCrotti/yasnippet-snippets.git
(use-package yasnippet
  :custom
  (yas-snippet-dirs '("/Users/peterwills/.emacs.d/yasnippet-snippets/")))

;; auto-completion for python
(use-package jedi
  :init (setq jedi:complete-on-dot t))

;; use C-c M-d to insert docstrings for functions
(use-package sphinx-doc
  :diminish sphinx-doc-mode
  :init
  (add-hook 'python-mode-hook (lambda () (sphinx-doc-mode t)))
  (setq sphinx-doc-all-arguments t))

;; We have to add ~/.local/bin to the path so that elpy can see flake8, which
;; we installed just for the user. Why did we do that? Well, I forget.
;;
;; For a fresh installation, you'll want to
;;
;;   pip install flake8 jedi autopep8 black yapf.
;;
;; This should get you full Elpy bells & whistles.
(use-package elpy
  :init
  (elpy-enable)
  (add-to-exec-path "~/.local/bin")
  (add-to-exec-path "/usr/local/bin")
  (add-hook 'elpy-mode-hook (lambda () (company-mode -1))) ;; this interferes with jedi
  (add-hook 'elpy-mode-hook #'jedi:setup)
  ;; elpy turns on highligh-indentation-mode, so I have to diminish it after
  (add-hook 'elpy-mode-hook (lambda () (diminish 'highlight-indentation-mode)))
  :custom
  (elpy-rpc-python-command "/usr/local/bin/python3")
  (python-shell-interpreter "/usr/local/bin/python3")
  (elpy-rpc-backend "jedi"))

;; slice-image prevents scrolling issues in EIN. See
;; https://github.com/tkf/emacs-ipython-notebook/issues/94 for more. Also, bind
;; clear all output to C-c C-x C-c. Meant to mirror C-c C-x C-r to restart
;; kernel, and avoids the awkward C-c C-S-l that clear-all-output defaults to.
(use-package ein
  :pin melpa
  :init
  (add-hook 'ein:notebook-mode-hook #'jedi:setup)
  :custom
  (ein:completion-backend 'ein:use-ac-backend)
  (ein:complete-on-dot t)
  (ein:truncate-long-cell-output nil)
  (ein:slice-image t)
  :bind
  ("C-c C-x C-c" . ein:worksheet-clear-all-output))

;; I like this for find-file and kill-buffer. It gets trumped by helm in a lot
;; of cases.
(use-package ido
  :init (ido-mode t))

(use-package helm
  :diminish helm-mode ;; don't show in mode-list
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
  :diminish which-key-mode
  :init (which-key-mode))

;; enable auto complete
(use-package auto-complete
  :diminish auto-complete-mode
  :init (global-auto-complete-mode t))

(use-package markdown-mode
  :custom (markdown-enable-math t))

(use-package yaml-mode)

;; I'm sure I would rewrite this using :hook, :mode, and so on, but I don't
;; understand them well enough to be confident in that.
(use-package tex
  :defer t
  :ensure auctex
  :init
  (setq exec-path (append exec-path '("/usr/texbin")))
  (setq exec-path (append exec-path '("/Library/TeX/texbin")))
  (server-start) ;; so skim can talk to emacs
  ;; a bunch of default settings I want
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (add-hook 'LaTeX-mode-hook 'auto-complete-mode)
  (add-to-list 'auto-mode-alist '("\\.tex$" . LaTeX-mode)); force LaTeX-mode
  ;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
  (add-hook 'LaTeX-mode-hook (lambda ()
                               (push
                                '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
                                  :help "Run latexmk on file")
                                TeX-command-list)))
  (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))
  :custom
  (TeX-parse-self t)
  (preview-auto-cache-preamble t)
  (TeX-save-query nil) ;; autosave before compiling
  (TeX-master nil)
  (reftex-plug-into-AUCTeX t)
  (TeX-PDF-mode t)
  ;; use Skim as default pdf viewer
  ;; Skim's displayline is used for forward search (from .tex to .pdf)
  ;; option -b highlights the current line; option -g opens Skim in the background  
  (TeX-view-program-selection '((output-pdf "PDF Viewer")))
  (TeX-view-program-list
        '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))
  (preview-gs-command "/usr/local/bin/gs"))

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
