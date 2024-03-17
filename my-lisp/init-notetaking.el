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
;; (setq org-hide-emphasis-markers t)

(use-package org-superstar
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode t))))

(setq org-fontify-quote-and-verse-blocks t) ;; 没有这个的话, quote 和 verse block 的 face 设置不生效

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

(custom-set-faces
 '(org-block ((t (:background "#112211")))) ;; src code block 里的内容
 '(org-block-begin-line ((t (:background "#223322")))) ;; #+begin_src 自身
 '(org-block-end-line ((t (:background "#223322")))) ;; #+end_src 自身
 '(org-meta-line ((t (:background "#223322")))))  ;; #+xxxx 开头的内容

(custom-set-faces
 '(org-quote ((t (:background "#334433"))))) ;; #+begin_quote #+end_quote 之间的内容

(custom-set-faces
 '(org-verbatim ((t (:background "#112211")))) ;; =xxxx= 里的内容
 '(org-code ((t (:background "#112211"))))) ;; ~xxxx~ 里的内容 

;; 太宽的行会在下一行显示，不再戳到右边看不见了
(add-hook 'org-mode-hook 'visual-line-mode)

(setq org-image-actual-width nil)
(setq org-startup-with-inline-images t)

(add-hook 'org-mode-hook #'turn-on-font-lock)
;; heading 和 content 做视觉上的缩进，实际内容没影响
(add-hook 'org-mode-hook 'org-indent-mode)

(use-package async :ensure t)

;; ========================================================================================================================
;; 用于把 clipboard 里的图像保存到 hard disk 中, 并在 .org 文件中插入图像链接
;; ========================================================================================================================
(defvar my-clipboard-image-save-directory "D:/"
  "Directory to save images from the clipboard.")

(defun save-clipboard-image-to-disk (timestamp)
  "Save an image from the clipboard to disk using the provided timestamp."
  (interactive "sTimestamp: ")
  (let* ((image-filename (concat (file-name-as-directory my-clipboard-image-save-directory) timestamp ".png")))
    (let ((powershell-cmd (concat "powershell -noprofile -command \""
                                  "Add-Type -AssemblyName System.Windows.Forms;"
                                  "Add-Type -AssemblyName System.Drawing;"
                                  "$img = [System.Windows.Forms.Clipboard]::GetImage();"
                                  "if ($img -ne $null) {"
                                  "[System.Drawing.Bitmap]$img.Save('" image-filename "', [System.Drawing.Imaging.ImageFormat]::Png);"
                                  "} else {"
                                  "Write-Host 'No image in clipboard.'"
                                  "}\"")))
      (shell-command powershell-cmd))
    image-filename))  ; Return the path of the saved image

(defun insert-image-from-clipboard-to-org ()
  "Save an image from the clipboard, insert an ATTR_HTML line for width control, and then insert a link to it in the current Org file."
  (interactive)
  (let* ((timestamp (format-time-string "%Y%m%d-%H%M%S"))
         (image-filename (concat (file-name-as-directory my-clipboard-image-save-directory) timestamp ".png")))
    (save-clipboard-image-to-disk timestamp)  ; Assuming save-clipboard-image-to-disk now accepts a timestamp argument
    (insert "#+ATTR_HTML: :width 800px\n")  ; Insert the #+ATTR_HTML line for width control
    (insert (format "[[file:%s]]\n" image-filename))  ; Insert the Org-mode link to the image
    (org-display-inline-images t t)  ; Refresh inline images to display the new image
    (message "Image has been successfully saved and inserted: %s" image-filename)))  ; Print the success message with the image path

(global-set-key (kbd "M-g p") 'insert-image-from-clipboard-to-org)
;; ========================================================================================================================

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


;; (setq org-startup-folded 'show2levels)
(setq org-startup-folded t)
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

