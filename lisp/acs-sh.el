;;; -*- lexical-binding: t; -*-


(acs/c:appdata/ eshell-directory-name /)
(acs/c:appdata/ eshell-history-file-name txt)
(acs/c:appdata/ eshell-last-dir-ring-file-name txt)


(add-hook 'eshell-mode-hook
        (lambda ()
        "‘eshell’ 中 ‘company-mode’ 卡得一批."
        (company-mode -1)))



(when (and (eq system-type 'windows-nt)
        (executable-find "pwsh.exe"))
(add-hook 'shell-mode-hook
        (lambda ()
            (when (not (file-remote-p default-directory))
            (execute-kbd-macro "set EMACS_INVOKED_PWSH=true 
pwsh.exe 
")))))

(add-hook 'shell-mode-hook
        (lambda ()
        "‘shell’中‘company-mode’卡得一批."
        (company-mode -1)))


(provide 'acs-sh)


;; Local Variables:
;; coding: utf-8-unix
;; End: