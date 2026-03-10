;;; -*- lexical-binding: t; -*-


;; lsp-bridge

(add-to-list 'load-path (file-name-concat user-emacs-directory "site-lisp/lsp-bridge"))
(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(setq lsp-bridge-python-command (or (executable-find "python3") "/usr/bin/python3.13"))
(global-lsp-bridge-mode)
(setq lsp-bridge-enable-diagnostics t)





(provide 'acs-plugin)

;; Local Variables:
;; coding: utf-8
;; End:
