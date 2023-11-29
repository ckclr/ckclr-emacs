;; --------------------------------------------------------------------------------
;; 基本内置选项设置
;; --------------------------------------------------------------------------------

(setq inhibit-startup-message t)

;; shift + 方向键来切换 window
(windmove-default-keybindings)

;; 记住window配置状态，C-c left or right来切换
(winner-mode 1)

;; 显示光标列数
(setq column-number-mode t)

;; 高亮当前行
(global-hl-line-mode 0)

;; 设置 tab 标签宽度
(setq-default tab-width 8)

;; frame 标题显示 buffer 名
(setq frame-title-format "%b")

;; gui 下才有的设置
(menu-bar-mode 0)
(if (display-graphic-p)
    (progn
      (toggle-scroll-bar 0)
      (tool-bar-mode 0)))

;; 关闭文件备份
(setq make-backup-files nil)

;; 选中后输入会删除
(delete-selection-mode 1)

;; 开启 narrow 功能
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; 开启全局行号
(global-display-line-numbers-mode)

;; 自动载入外部修改
(global-auto-revert-mode t)

;; 平滑滚动
(setq scroll-conservatively 100)
;; 鼠标平滑滚动
(setq mouse-wheel-scroll-amount '(5 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; 让 dired mode 中目录排在前面
(require 'ls-lisp)
(setq ls-lisp-dirs-first t)
(setq ls-lisp-use-insert-directory-program nil)

;; force line wrap to wrap at word boundaries
(setq-default word-wrap t)

(add-to-list 'default-frame-alist '(width  . 128))
(add-to-list 'default-frame-alist '(height . 32))
(add-to-list 'default-frame-alist '(font . "Sarasa Term Slab SC 12"))
;; (add-to-list 'default-frame-alist '(font . "LXGW Wenkai Mono 12"))

;; 默认编码为 utf-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; --------------------------------------------------------------------------------
;; 基本 key binding
;; --------------------------------------------------------------------------------

;; open init.el
;; global-set-key expects an interactive command. ref: https://stackoverflow.com/q/1250846
(global-set-key (kbd "M-g i") (lambda () (interactive) (find-file user-init-file)))

;; eval init file
(global-set-key (kbd "M-g e") (lambda () (interactive) (eval-expression (load-file user-init-file))))

;; toggle comment
(global-set-key (kbd "M-;") 'comment-line)

;; 在 c/c++ mode 中切换头/源文件
(add-hook 'c-mode-hook   (lambda () local-set-key (kbd "M-o") 'ff-find-other-file))
(add-hook 'c++-mode-hook (lambda () local-set-key (kbd "M-o") 'ff-find-other-file))

;; 最近打开的文件
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)



;; --------------------------------------------------------------------------------
;; 插件
;; --------------------------------------------------------------------------------

(add-to-list 'load-path (expand-file-name "elisp.fsz" user-emacs-directory))
(add-to-list 'native-comp-eln-load-path "~/eln-cache")
(setq package-user-dir "~/elpa.fsz")
(setq custom-file (locate-user-emacs-file "custom.el"))

(require 'package)
(setq package-enable-at-startup nil)
(setq user-home-directory (file-truename "~/"))
(setq package-archives
      `(("melpa" . ,(concat user-home-directory ".elpa-mirror/melpa/"))
        ("org"   . ,(concat user-home-directory ".elpa-mirror/org/"))
        ("gnu"   . ,(concat user-home-directory ".elpa-mirror/gnu/"))))
(package-initialize)

;;防止反复调用 package-refresh-contents 会影响加载速度
(unless package-archive-contents (package-refresh-contents))

;; Bootstrap use-package
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

;; (eval-when-compile
;;   (require 'use-package))

;; 只能对 init 之后的操作做 benchmark，所示要尽量往前放
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

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
  (setq company-idle-delay 0.2)
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

(use-package org-remark
  :ensure t
  :init
  (tooltip-mode -1)) ;; echo 区显示比 tooltip 显示更迅速
;; Key-bind `org-remark-mark' to global-map so that you can call it
;; globally before the library is loaded.
(define-key global-map (kbd "C-c n m") #'org-remark-mark)
;; The rest of keybidings are done only on loading `org-remark'
(with-eval-after-load 'org-remark
  (define-key org-remark-mode-map (kbd "C-c n o") #'org-remark-open)
  (define-key org-remark-mode-map (kbd "C-c n ]") #'org-remark-view-next)
  (define-key org-remark-mode-map (kbd "C-c n [") #'org-remark-view-prev)
  (define-key org-remark-mode-map (kbd "C-c n r") #'org-remark-remove))

(use-package projectile
  :ensure t
  :config
  (projectile-mode t)
  :bind
  ("C-c p" . projectile-command-map))

(when (eq system-type 'windows-nt)
  (setq locale-coding-system 'gb18030)  ;此句保证中文字体设置有效
  (setq w32-unicode-filenames 'nil)       ; 确保file-name-coding-system变量的设置不会无效
  (setq file-name-coding-system 'gb18030)) ; 设置文件名的编码为gb18030




;; --------------------------------------------------------------------------------
;; org-mode 配置
;; --------------------------------------------------------------------------------
;; 隐藏重点标记符号
;; (setq org-hide-emphasis-markers nil)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode t))))

(custom-theme-set-faces
 'user
 '(org-level-4 ((t (:inherit :default :weight bold :height 1.1))))
 '(org-level-3 ((t (:inherit :default :weight bold :height 1.1))))
 '(org-level-2 ((t (:inherit :default :weight bold :height 1.1))))
 '(org-level-1 ((t (:inherit :default :weight bold :height 1.1))))
 '(org-block ((t (:inherit :default))))
 '(org-block-begin-line ((t (:inherit :default))))
 '(org-block-end-line ((t (:inherit :default))))
 '(org-code ((t (:inherit :default))))
 '(org-property-value ((t (:inherit :default))))
 '(org-special-keyword ((t (:inherit :default))))
 '(org-meta-line ((t (:inherit :default))))
 '(org-drawer ((t (:inherit :default))))
 '(org-document-title ((t (:inherit :default))))
 '(org-document-info ((t (:inherit :default))))
 '(org-document-info-keyword ((t (:inherit :default))))
 '(org-table ((t (:inherit :default)))))

;; 太宽的行会在下一行显示，不再戳到右边看不见了
(add-hook 'org-mode-hook 'visual-line-mode)

(setq org-image-actual-width nil)
(setq org-startup-with-inline-images t)

;; (add-hook 'org-mode-hook #'turn-on-font-lock)
;; heading 和 content 做视觉上的缩进，实际内容没影响
(add-hook 'org-mode-hook 'org-indent-mode)

(use-package async :ensure t)
(add-to-list 'load-path "~/.emacs.d/site-lisp/org-download/")
(require 'org-download)
(setq-default org-download-image-dir "D:/fsz-org/assets")
(define-key global-map (kbd "M-g p") #'org-download-clipboard)

(use-package pdf-tools
  :ensure t
  :init
  (pdf-loader-install)) ;; 这句关键，没有的话 windows 默认依然用 docview
(add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))

(use-package org-transclusion :ensure t :defer t)
(define-key global-map (kbd "<f12>") #'org-transclusion-add)
(define-key global-map (kbd "C-c n t") #'org-transclusion-mode)
(define-key global-map (kbd "C-c n a") #'org-transclusion-add-all)
(define-key global-map (kbd "C-c n r") #'org-transclusion-remove-all)

(use-package org-fragtog
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-fragtog-mode)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
  (setq org-src-fontify-natively t))


;; (add-to-list 'load-path "~/.emacs.d/site-lisp/org-inline-image-fix/")
;; (with-eval-after-load "org"
;;   (require 'org-limit-image-size)
;;   (org-limit-image-size-activate))

;; (cond ((<= (display-pixel-height) 1080) (setq org-limit-image-size '(800 . 800)))
;;       ((<= (display-pixel-height) 1440) (setq org-limit-image-size '(1000 . 1000))))

(setq org-startup-folded 'show2levels)
(setq org-startup-with-latex-preview t)
(setq org-startup-with-inline-images t)
(setq org-preview-latex-image-directory "D:/ltximg/")

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

(use-package org-noter
  :ensure t
  :config
  (setq org-noter-highlight-selected-text t))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "D:/fsz-org/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-journal
  :ensure t
  :defer t
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c j ")
  :config
  (setq org-journal-dir "D:/fsz-org/journal"
        org-journal-file-format "%Y.org"
        org-journal-date-format "%Y-%m-%d %A"
        org-journal-file-type 'yearly))

(defun org-journal-file-header-func (time)
  "Custom function to create journal header."
  (concat
   (pcase org-journal-file-type
     ('daily "#+TITLE: Daily Journal\n#+STARTUP: showeverything")
     ('weekly "#+TITLE: Weekly Journal\n#+STARTUP: folded")
     ('monthly "#+TITLE: Monthly Journal\n#+STARTUP: folded")
     ('yearly "#+TITLE: Yearly Journal\n#+STARTUP: folded"))))
(setq org-journal-file-header 'org-journal-file-header-func)

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

(use-package zenburn-theme
  :ensure t)
(load-theme 'zenburn t)
;; (load-theme 'modus-vivendi t)
;; (load-theme 'modus-operandi t)
