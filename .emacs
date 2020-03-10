; gem pristine --all
(setq user-full-name "Brian Henning"
      user-mail-address "henninb@msn.com")

(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)


(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))


 (unless (package-installed-p 'evil)
   (package-install 'evil))

;(menu-bar-mode -1)
;(toggle-scroll-bar -1)
;(tool-bar-mode -1)
;(blink-cursor-mode -1)

; visual helpers
(global-hl-line-mode +1)
(line-number-mode +1)
(global-display-line-numbers-mode 1)
(column-number-mode t)
(size-indication-mode t)

; disable startup screen
(setq inhibit-startup-screen t)

; disable scratch pad message
(setq initial-scratch-message "")

(setq frame-title-format
      '((:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
       "%b"))))

(setq scroll-margin 0
            scroll-conservatively 100000
                  scroll-preserve-screen-position 1)

(set-frame-font "monofur for Powerline-18" nil t)
;(set-face-attribute 'default nil :height 150)

; theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config))

; smart mode line
(use-package smart-mode-line-powerline-theme
  :ensure t)

(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'powerline)
  (add-hook 'after-init-hook 'sml/setup))

; send backup files to the temp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


; fix the yes no prompts
(fset 'yes-or-no-p 'y-or-n-p)

; reload files during external edits
(global-auto-revert-mode t)

; set tabs to 4 spaces
(setq-default tab-width 4
              indent-tabs-mode nil)

; map kill buffer binding
(global-set-key (kbd "C-x k") 'kill-this-buffer)

; auto clean whitespace noise
(add-hook 'before-save-hook 'whitespace-cleanup)

(add-to-list 'default-frame-alist '(fullscreen . maximized))


(use-package diminish
  :ensure t)


;; load evil
; (use-package evil
;   :ensure t ;; install the evil package if not installed
;   :init ;; tweak evil's configuration before loading it
;   (setq evil-search-module 'evil-search)
;   (setq evil-ex-complete-emacs-commands nil)
;   (setq evil-vsplit-window-right t)
;   (setq evil-split-window-below t)
;   (setq evil-shift-round nil)
;   (setq evil-want-C-u-scroll t)
;   :config ;; tweak evil after loading it
;   (evil-mode)

; toggle evil mode Ctl-z
 (require 'evil)
   (evil-mode 1)

; smart parens in  emacs
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (show-paren-mode t)))

(use-package expand-region
  :ensure t
  :bind ("M-m" . er/expand-region))

; useful adons
(use-package crux
  :ensure t
  :bind
  ("C-k" . crux-smart-kill-line)
  ("C-c n" . crux-cleanup-buffer-or-region)
  ("C-c f" . crux-recentf-find-file)
  ("C-a" . crux-move-beginning-of-line))

; keystroke suggestion tool
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode +1))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

; Autocomplete and syntax checking
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

; git package
(use-package magit
  :bind (("C-M-g" . magit-status)))

(defun toggle-evilmode ()
  (interactive)
  (if (bound-and-true-p evil-local-mode)
    (progn
      ; go emacs
      (evil-local-mode (or -1 1))
      (undo-tree-mode (or -1 1))
      (set-variable 'cursor-type 'bar)
    )
    (progn
      ; go evil
      (evil-local-mode (or 1 1))
      (set-variable 'cursor-type 'box)
    )
  )
)

;(global-set-key (kbd "M-u") 'toggle-evilmode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" default)))
 '(package-selected-packages
   (quote
    (diminish use-package smart-mode-line-powerline-theme doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )