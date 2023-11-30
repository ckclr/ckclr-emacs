;; -*- lexical-binding: t -*-

;; --------------------------------------------------------------------------------
;; 插件基础配置
;; --------------------------------------------------------------------------------
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      `(("melpa" . ,(concat user-home-directory ".elpa-mirror/melpa/"))
        ("org"   . ,(concat user-home-directory ".elpa-mirror/org/"))
        ("gnu"   . ,(concat user-home-directory ".elpa-mirror/gnu/"))))
(package-initialize)
;;防止反复调用 package-refresh-contents 会影响加载速度
(unless package-archive-contents (package-refresh-contents))

;; 只能对 benchmark-init 之后的操作做 benchmark，所示要尽量往前放
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(provide 'init-package)

