;; -*- lexical-binding: t -*-
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

(when (eq system-type 'windows-nt)
  (setq locale-coding-system 'gb18030)  ;此句保证中文字体设置有效
  (setq w32-unicode-filenames 'nil)       ; 确保file-name-coding-system变量的设置不会无效
  (setq file-name-coding-system 'gb18030)) ; 设置文件名的编码为gb18030

(provide 'init-basic)

