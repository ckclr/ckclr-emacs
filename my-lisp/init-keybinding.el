;; -*- lexical-binding: t -*-

;; --------------------------------------------------------------------------------
;; 基本 key binding
;; --------------------------------------------------------------------------------

;; open init.el
;; global-set-key expects an interactive command. ref: https://stackoverflow.com/q/1250846
(global-set-key (kbd "M-g -") (lambda () (interactive) (find-file user-init-file)))

;; eval init file
(global-set-key (kbd "M-g +") (lambda () (interactive) (eval-expression (load-file user-init-file))))

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

(provide 'init-keybinding)

