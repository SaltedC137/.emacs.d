;;; -*- lexical-binding: t; -*-

;; (add-to-list 'load-path (expand-file-name "bin" user-emacs-directory))

;; (use-package vterm
;;   :load-path "~/.emacs.d/bin/"
;;   :config
;;   (when (and (eq system-type 'windows-nt)
;;               (executable-find "pwsh.exe"))
;;     (setq vterm-shell "pwsh.exe -NoLogo"))
;;   (add-hook 'vterm-mode-hook
;;             (lambda ()
;;               "vterm 界面优化，保持与旧版 eshell/shell 一致的体验"
;;               (company-mode -1)
;;               (when (boundp 'display-line-numbers-mode)
;;                 (display-line-numbers-mode -1))))  
;;   (setq vterm-max-scrollback 10000))

;; (provide 'acs-sh)

;; Local Variables:
;; coding: utf-8
;; End:
