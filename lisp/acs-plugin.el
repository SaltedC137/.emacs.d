;;; -*- lexical-binding: t; -*-

(add-to-list 'load-path (file-name-concat user-emacs-directory "site-lisp/lsp-bridge"))

(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)

(setq lsp-bridge-python-command "C:/Users/SallyFace/AppData/Local/Programs/Python/Python313/python.exe")
(global-lsp-bridge-mode)

(setq lsp-bridge-enable-diagnostics t)

(provide 'acs-plugin)




;; Local Variables:
;; coding: utf-8
;; End: