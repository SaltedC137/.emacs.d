;;; -*- lexical-binding: t; -*-


(use-package powershell
    :straight t
    :config
    ;; Change default compile command for powershell
    (add-hook 'powershell-mode-hook
    (lambda ()
        (set (make-local-variable 'compile-command)
        (format "pwsh.exe -NoLogo -NonInteractive -Command \"& '%s'\""   (buffer-file-name)))))
)

(provide 'acs-sh)

;; Local Variables:
;; coding: utf-8-unix
;; End: