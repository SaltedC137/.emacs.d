;;; init-kbd.el --- configs for key bind -*- lexical-binding: t -*-

;; Author: Cabins
;; Maintainer: Cabins
;; Version: 1.0
;; Package-Requires: ()
;; Homepage: https://github.com/cabins
;; Keywords:

;;; Commentary:
;; (c) Cabins Kong, 2020-2021

;;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    Global Keybinds Dependencies
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package crux)
(use-package format-all
  :diminish " Fmt."
  :commands (format-all-buffer format-all-region))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;                   Global Key Bindings
;;
;; 当前版本全局按键绑定秉承以下原则：
;; 1. 自定义全局按键尽可能以C-c开头（或绑F5-F9），此为Emacs设计规范预期
;; 2. 记忆方式上，尽可能VSCode相近，因同在用VSCode
;; 3. 不违背Emacs Quirks [http://ergoemacs.org/emacs/keyboard_shortcuts.html]
;; 4. 为方便统一管理，全局按键不分散于use-package中，模式按键仍在use-package中
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Emacs Basic Keys ------------------------------
(defalias 'yes-or-no-p 'y-or-n-p)

(require 'ido)
(ido-mode t)
(require 'smex)
(global-set-key (kbd "M-x") 'smex) ; Enhanced M-x


(global-set-key (kbd "C-c ,") #'crux-find-user-init-file)	; Open Settings
(global-set-key (kbd "C-c l") (lambda () (interactive) (load-file user-init-file))) ; Reload Settings
(global-set-key (kbd "C-c r") 'recentf-open-files) ; Open Recent Files
(global-set-key (kbd "C-x C-g") 'find-file-at-point) ; 跳转到光标处的文件
(global-set-key (kbd "C-c i m") 'imenu)             ; 快速跳转函数符号
(global-set-key (kbd "C-c T") 'rc/toggle-transparency) ; 切换透明度

;; Window Move
(global-set-key (kbd "C-c <left>") 'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>") 'windmove-up)
(global-set-key (kbd "C-c <down>") 'windmove-down)

;; Zoom
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-0") (lambda () (interactive) (text-scale-set 0)))

;; Window Split
(global-set-key (kbd "C-c v") 'split-window-right)
(global-set-key (kbd "C-c s") 'split-window-below)
(global-set-key (kbd "C-c w") 'delete-window)
(global-set-key (kbd "C-c 1") 'delete-other-windows)

;;; Code Editing ------------------------------
;; Comments（As C-x C-; is for comment-line, keep the postfix）
(global-set-key (kbd "C-c C-;") #'comment-or-uncomment-region)
;; Line Edit
(global-set-key (kbd "M-<down>") #'drag-stuff-down)
(global-set-key (kbd "M-<up>") #'drag-stuff-up)
(global-set-key (kbd "C-c C-d") #'crux-duplicate-current-line-or-region)
(global-set-key (kbd "C-a") #'crux-move-beginning-of-line)
;; Delete
(global-set-key (kbd "C-c <backspace>") #'hungry-delete-backward)
(global-set-key (kbd "C-c <delete>") #'hungry-delete-forward)
;; Code Beautify
(global-set-key (kbd "C-o") #'yas-expand)
(global-set-key (kbd "C-c f") #'format-all-buffer)
(global-set-key (kbd "C-c C-f") #'format-all-region)
;; Syntax
(global-set-key (kbd "M-.") #'xref-find-definitions)
(global-set-key (kbd "M-,") #'xref-go-back)
(global-set-key (kbd "M-?") #'xref-find-references)
(global-set-key (kbd "M-n") #'flymake-goto-next-error)
(global-set-key (kbd "M-p") #'flymake-goto-prev-error)
(global-set-key (kbd "C-c e l") #'flymake-show-buffer-diagnostics)
(global-set-key (kbd "C-c e h") #'eldoc-doc-buffer)

;; Custom Utils
(global-set-key (kbd "C-,") #'rc/duplicate-line)
(global-set-key (kbd "C-x p d") #'rc/insert-timestamp)
(global-set-key (kbd "C-x p s") #'rc/rgrep-selected)
(global-set-key (kbd "C-c M-q") #'rc/unfill-paragraph)
(global-set-key (kbd "C-c X") #'bf-pretty-print-xml-region)

;;; GDB Debugging Keys (VSCode style with Fn keys) -------
;; F5: start gdb or continue
(global-set-key (kbd "<f5>") (lambda () (interactive)
                               (if (get-buffer "*gud*")
                                   (with-current-buffer "*gud*"
                                     (comint-send-input))
                                 (call-interactively 'gdb))))

;; F9: toggle breakpoint
(global-set-key (kbd "<f9>") (lambda () (interactive)
                               (with-current-buffer (or gud-comint-buffer (current-buffer))
                                 (gud-call "break %f:%l" nil))))

;; F10: Step over (next)
(global-set-key (kbd "<f10>") (lambda () (interactive)
                                (with-current-buffer (or gud-comint-buffer (current-buffer))
                                  (gud-call "next" nil))))

;; F11: Step into
(global-set-key (kbd "<f11>") (lambda () (interactive)
                                (with-current-buffer (or gud-comint-buffer (current-buffer))
                                  (gud-call "step" nil))))

;; Shift+F11: Step out (finish)
(global-set-key (kbd "<S-f11>") (lambda () (interactive)
                                  (with-current-buffer (or gud-comint-buffer (current-buffer))
                                    (gud-call "finish" nil))))

;; Ctrl+F5: Continue execution
(global-set-key (kbd "<C-f5>") (lambda () (interactive)
                                 (with-current-buffer (or gud-comint-buffer (current-buffer))
                                   (gud-call "continue" nil))))




;; F8: Start GDB
(global-set-key (kbd "<f8>") 'gdb)

;; Ctrl+Shift+F5: Quit GDB and close window
(global-set-key (kbd "<C-S-f5>") (lambda () (interactive)
                                   (if (get-buffer "*gud*")
                                       (with-current-buffer "*gud*"
                                         (gud-call "quit" nil)
                                         (sleep-for 0.5)
                                         (kill-buffer "*gud*")
                                         (delete-other-windows)))))

(provide 'init-kbd)

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
;;; init-kbd.el ends here
