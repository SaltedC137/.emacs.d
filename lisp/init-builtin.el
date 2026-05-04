;;; init-builtin.el --- initialize the builtin plugins -*- lexical-binding: t -*-

;; Author: Cabins
;; Maintainer: Cabins
;; Version: 1.0
;; Package-Requires: ()
;; Homepage: https://github.com/cabins
;; Keywords:

;;; Commentary:
;; (c) Cabins Kong, 2020-2021

;;; Code:
;;; Sorted by Alphbet order

(defalias 'yes-or-no-p 'y-or-n-p)

;; Abbrev
(setq-default abbrev-mode t)

;; auto save
;; `save-some-buffers' is provided by files.el (builtin)
;; `pulse-momentary-highlight-one-line' is provided by pulse.el (builtin)
(use-package pulse
  :ensure nil
  :init
  (require 'pulse)
  (defun cabins/save-current-buffer-maybe ()
    "Save current file buffer if it is modified."
    (when (and (buffer-file-name)
               (buffer-modified-p)
               (file-writable-p (buffer-file-name)))
      (save-buffer)
      (pulse-momentary-highlight-one-line (point))))
  (defun cabins/save-current-buffer-on-focus-out ()
    "Save current buffer when frame loses focus."
    (unless (frame-focus-state)
      (cabins/save-current-buffer-maybe)))
  ;; Save only on focus-out and idle, not on every buffer switch.
  (add-function :after after-focus-change-function #'cabins/save-current-buffer-on-focus-out)
  (run-with-idle-timer 8 t #'cabins/save-current-buffer-maybe))

;; auto revert
;; `global-auto-revert-mode' is provided by autorevert.el (builtin)
(use-package autorevert
  :hook (after-init . global-auto-revert-mode))

;; Delete Behavior
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'after-init-hook 'delete-selection-mode)

;; Electric-Pair
(add-hook 'after-init-hook 'electric-indent-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'electric-layout-mode)

;; Flymake
(add-hook 'prog-mode-hook 'flymake-mode)

;; HideShow Minor Mode
(use-package hideshow
  :init (add-hook 'hs-minor-mode-hook (lambda () (diminish 'hs-minor-mode)))
  :hook (prog-mode . hs-minor-mode))

;; ibuffer
(use-package ibuffer
  :init (defalias 'list-buffers 'ibuffer))

;; Ido ( instead of ivy & counsel & swiper)
(setq-default ido-auto-merge-work-directories-length -1
	          ido-enable-flex-matching t
	          isearch-lazy-count t
	          laz2y-count-prefix-format "%s/%s: ")
(setq completion-ignored-extensions '(".o" ".elc" "~" ".bin" ".bak" ".obj" ".map" ".a" ".ln" ".class"))
(fido-mode t)

;; Line Number
;; Display line numbers globally in all buffers (Emacs 26+)
(use-package display-line-numbers
  :if (> emacs-major-version 26)
  :init (global-display-line-numbers-mode 1)
  :custom (display-line-numbers-type 'relative)
  :hook ((text-mode prog-mode conf-mode) . display-line-numbers-mode))

;; Org Mode
(setq org-hide-leading-stars t
      org-startup-indented t
      org-startup-with-inline-images t
      org-image-actual-width nil)
(add-hook 'org-mode-hook #'org-display-inline-images)

;; Parentheses
(use-package paren
  :ensure nil
  :config (setq-default show-paren-style 'mixed
                        show-paren-when-point-inside-paren t
                        show-paren-when-point-in-periphery t)
  :hook (prog-mode . show-paren-mode))

;; Recent Files
(add-hook 'after-init-hook (lambda ()
			                 (recentf-mode 1)
			                 (add-to-list 'recentf-exclude '("~\/.emacs.d\/elpa\/"))))
(setq-default recentf-max-menu-items 20
	          recentf-max-saved-items 20)

;; Save Place
(save-place-mode 1)

;; only use spaces instead of TAB, use C-q TAB to input the TAB char
(setq-default indent-tabs-mode nil
              tab-width 2
              standard-indent 2
              c-basic-offset 2
              c-ts-mode-indent-offset 2
              c++-ts-mode-indent-offset 2)

;; Diminish Builtins
(dolist (elem '(abbrev-mode eldoc-mode))
  (diminish elem))
(add-hook 'hs-minor-mode-hook (lambda () (diminish 'hs-minor-mode)))


;; smooth scrolling

(setq scroll_step 1
      scroll_conservatively 101
      scroll_margin 2)

(provide 'init-builtin)

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
;;; init-builtin.el ends here
