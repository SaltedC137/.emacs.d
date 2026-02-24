;;; -*- lexical-binding: t; -*-

;; See (info "(emacs) Package Installation")
;;
;;      Installed packages are automatically made available by Emacs
;;   in all subsequent sessions.  This happens at startup, before
;;   processing the init file but after processing the early init
;;   file.

(setopt package-quickstart nil  ; 每次启动时 re-computing 而不是 使用 precomputed 的文件.
        ;; 相当于在 加载“init.el” 前 执行‘package-initialize’.
        ;; 这其实是 默认行为.
        package-enable-at-startup t)

(acs/custom:appdata/ package-user-dir /)

(setopt network-security-level 'low)

(setopt package-archives '(
                        ("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                        ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
                        ("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                        ))

(provide 'acs-package)

;; Local Variables:
;; coding: utf-8-unix
;; End: