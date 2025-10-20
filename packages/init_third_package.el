


;;benchmark-init
;; (use-package benchmark-init
;;   :ensure t
;;   :config (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; Settings for company, auto-complete only for coding.

(use-package company
    :ensure t
    :init (global-company-mode)
    :config
    (setq company-minimum-prefix-length 1) ; 只需敲 1 个字母就开始进行自动补全
    (setq company-tooltip-align-annotations t)
    (setq company-idle-delay 0.0)
    (setq company-show-numbers t)   ;; 给选项编号 (按快捷键 M-1、M-2 等等来进行选择).
    (setq company-selection-wrap-around t)
    (setq company-transformers '(company-sort-by-occurrence)))



(use-package company-box
    :ensure t
    :if window-system
    :hook (company-mode . company-box-mode))



(use-package yasnippet
    :ensure t
    :hook
    (prog-mode . yas-minor-mode)
    :config
    (yas-reload-all)
    ;; add company-yasnippet to company-backends
    (defun company-mode/backend-with-yas (backend)
    (if (and (listp backend) (member 'company-yasnippet backend))
    backend
    (append (if (consp backend) backend (list backend))
        '(:with company-yasnippet))))
    (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
    ;; unbind <TAB> completion
    (define-key yas-minor-mode-map [(tab)]    nil)
    (define-key yas-minor-mode-map (kbd "TAB")  nil)
    (define-key yas-minor-mode-map (kbd "<tab>") nil)
    :bind
    (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))

(use-package yasnippet-snippets
    :ensure t
    :after yasnippet)

(use-package lsp-mode
    :ensure t
    :init
    ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
    (setq lsp-keymap-prefix "C-c l"
	lsp-file-watch-threshold 500)
    :hook  (lsp-mode . lsp-enable-which-key-integration) ; which-key integration
    :commands (lsp lsp-deferred)
    :config
    (setq lsp-completion-provider :none) ;; 阻止 lsp 重新设置 company-backend 而覆盖我们 yasnippet 的设置
    (setq lsp-headerline-breadcrumb-enable t)
    :bind
    ("C-c l s" . lsp-ivy-workspace-symbol)) 


(use-package lsp-ui
    :ensure t
    :config
    (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
    (setq lsp-ui-doc-position 'top))

(use-package lsp-ivy
    :ensure t
    :after (lsp-mode))

(provide 'init_third_package)