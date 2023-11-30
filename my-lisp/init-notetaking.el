;; -*- lexical-binding: t -*-

;; --------------------------------------------------------------------------------
;; org-mode 配置
;; --------------------------------------------------------------------------------

;; 平滑滚动图像
(use-package iscroll
  :ensure t
  :config
  ;; 作者说性能有点问题，所以只在 org-mode 下打开
  (add-hook 'org-mode-hook (lambda () (iscroll-mode t))))

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

;; 隐藏重点标记符号
(setq org-hide-emphasis-markers nil)

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

(add-hook 'org-mode-hook #'turn-on-font-lock)
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


(setq org-startup-folded 'show2levels)
(setq org-startup-with-latex-preview t)
(setq org-startup-with-inline-images t)
(setq org-preview-latex-image-directory "D:/ltximg/")

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

(setq org-src-preserve-indentation nil
      org-edit-src-content-indentation 0)

(provide 'init-notetaking)

