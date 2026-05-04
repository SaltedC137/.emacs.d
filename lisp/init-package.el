;;; init-package.el --- initialize the plugins -*- lexical-binding: t -*-

;; Author: Cabins
;; Maintainer: Cabins
;; Version: 1.0
;; Package-Requires: ()
;; Homepage: https://github.com/cabins
;; Keywords:

;;; Commentary:
;; (c) Cabins Kong, 2020-2021

;;; Code:

(defun cabins/defer-startup (delay fn)
  "Run FN DELAY seconds after Emacs becomes idle post startup."
  (add-hook 'after-init-hook
           (lambda ()
              (run-with-idle-timer delay nil fn))))

;; All the icons
;; If the icons are not displayed correctly although all-the-icons fonts are installed correctly
;; please install the non-free font Symbola. This issue usually occurs on Windows.
;; [Refs] https://github.com/seagle0128/doom-modeline
(use-package all-the-icons
  :when (display-graphic-p))

;; Auto update packages
;; this maybe useful, if you want to update all the packages with command, just like me
(use-package auto-package-update
  :init (setq auto-package-update-delete-old-versions t
	            auto-package-update-hide-results t))

;; Settings for company
(use-package company
  :diminish
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-show-quick-access t))

;; collections of useful command
(use-package crux)

;; ctrlf, good isearch alternative
(use-package ctrlf
  :commands (ctrlf-mode)
  :init (cabins/defer-startup 0.4 #'ctrlf-mode))

;; Settings for exec-path-from-shell
(use-package exec-path-from-shell
  :defer nil
  ;; Keep this only on macOS where GUI Emacs often misses shell env vars.
  :if (memq window-system '(mac ns))
  :init (exec-path-from-shell-initialize))

;; format all, formatter for almost languages
;; great for programmers
(use-package format-all
  :diminish
  :commands (format-all-buffer format-all-region)
  :bind ("C-c f" . #'format-all-buffer))

;; hungry delete, delete many spaces as one
(use-package hungry-delete
  :diminish
  :commands (global-hungry-delete-mode)
  :init (cabins/defer-startup 0.6 #'global-hungry-delete-mode))

;; move-text, move line or region with M-<up>/<down>
(use-package move-text
  :commands (move-text-default-bindings)
  :init (cabins/defer-startup 0.8 #'move-text-default-bindings))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C-c d" . mc/mark-next-like-this)
         ("C-c D" . mc/mark-all-like-this)
         ("C-c m s" . mc/skip-to-next-like-this)
         ("C-S-c C-S-c" . mc/edit-lines))
  :config
  ;; 让 mc 自动对所有光标运行已知的安全命令
  (setq mc/always-run-for-all t))

;; Settings for projectile (use builtin project in Emacs 28)
(use-package projectile
  :when (< emacs-major-version 28)
  :diminish " Proj."
  :commands (projectile-mode)
  :init (cabins/defer-startup 1.0 #'projectile-mode)
  :config (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; Show the delimiters as rainbow color
(use-package rainbow-delimiters
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
(use-package highlight-parentheses
  :init (add-hook 'prog-mode-hook 'highlight-parentheses-mode))


;; Settings for which-key - suggest next key
(use-package which-key
  :commands (which-key-mode)
  :diminish
  :init (cabins/defer-startup 1.2 #'which-key-mode))

;; Settings for yasnippet
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))
(use-package yasnippet-snippets)

(provide 'init-package)

;; cmake for lsp
(use-package cmake-mode
  :ensure t)

;; org-download

(use-package org-download
  :ensure t
  :after org
  :hook (org-mode . org-download-enable)
  :config
  (setq org-download-heading-lvl nil
        org-download-image-dir "./img"
        org-download-annotate-function #'ignore
        ;; Temporary screenshot path; final image will be saved to org-download-image-dir.
        org-download-screenshot-file
        (expand-file-name "org-download-screenshot.png" temporary-file-directory)))

;; copilot

(use-package copilot
  :ensure t
  :commands (copilot-mode)
  :custom
  (copilot-indent-offset-warning-disable t)
  :bind (("C-c o" . copilot-mode)
         :map copilot-completion-map
         ("<tab>" . copilot-accept-completion)
         ("TAB" . copilot-accept-completion)
         ("C-<tab>" . copilot-accept-completion-by-word)
         ("C-TAB" . copilot-accept-completion-by-word)
         ("C-n" . copilot-next-completion)
         ("C-p" . copilot-previous-completion)))

;; highlight-indent-guides
(use-package diredfl
  :hook (dired-mode . diredfl-mode))
(add-hook 'dired-mode-hook 'hl-line-mode)


;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
;;; init-package.el ends here
