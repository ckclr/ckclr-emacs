;; -*- lexical-binding: t -*-
(add-to-list 'load-path (expand-file-name "my-lisp" user-emacs-directory))
(add-to-list 'native-comp-eln-load-path "~/eln-cache")
(setq user-home-directory (file-truename "~/"))
(setq package-user-dir "~/emacs-package")
(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file 'no-error 'no-message)

(require 'init-basic)
(require 'init-keybinding)
(require 'init-package)
(require 'init-notetaking)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package company
  :ensure t
  :init
  (global-company-mode t)
  :config
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.3)
  :bind (:map company-active-map
	      ("C-n" . 'company-select-next)
	      ("C-p" . 'company-select-previous)))
(setq company-global-modes '(not eshell-mode))

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package eglot
  :ensure t
  :config
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio"))))

(use-package blacken
  :ensure t
  :config
  (setq blacken-line-length 1024))
(add-hook 'python-mode-hook   (lambda () local-set-key (kbd "M-g f") 'blacken-buffer))

;; minibuffer 的垂直补全，类似 ivy
(use-package vertico
  :ensure t
  :init
  (vertico-mode t))

;; minibuffer 的无序模糊搜索
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless)))

;; minibuffer 搜索候选加 annotation
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode t))

(use-package embark
  :ensure t)

(use-package consult
  :ensure t)

(use-package embark-consult
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-mode t)
  :bind
  ("C-c p" . projectile-command-map))

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-use-term-integration t))

(use-package zenburn-theme :ensure t)
(load-theme 'zenburn t)
;; (load-theme 'modus-vivendi t)
;; (load-theme 'modus-operandi t)
;; (load-theme 'wombat)


