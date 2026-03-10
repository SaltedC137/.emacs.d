;;; -*- lexical-binding: t; -*-


;;; rc/duplicate-line

(defun rc/duplicate-line()
  "duplicate current  line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
(forward-char column)))

(keymap-global-set  "C-," #'rc/duplicate-line)

;; Rc/insert-timestamp (2026.03.05-09:51:28) 

(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "(%Y.%m.%d-%H:%M:%S)" nil 28800)))

(global-set-key (kbd "C-x p d") 'rc/insert-timestamp)

;; tab width


(setq tab-width 4
      indent-tabs-mode nil
      standard-indent 4)


(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(dolist (mode '(python-mode-hook
                c-mode-hook
                c++-mode-hook
                java-mode-hook
                javascript-mode-hook
                web-mode-hook
                yaml-mode-hook
                ruby-mode-hook
                go-mode-hook
                rust-mode-hook))
  (add-hook mode (lambda ()
                   (setq tab-width 4
                         indent-tabs-mode nil
                         standard-indent 4))))

;; editor keyset

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)

;; move text up&down

(keymap-global-set "M-<up>" #'move-text-up)
(keymap-global-set "M-<down>" #'move-text-down)

;; tab line & buffer control

(keymap-global-set  "C-c k" #'tab-line-switch-to-next-tab)
(keymap-global-set  "C-c j" #'tab-line-switch-to-prev-tab)
(keymap-global-set  "C-c l" #'kill-current-buffer)

;; multiple-cursors

(keymap-global-set  "C-S-c C-S-c" #'mc/edit-lines)
(keymap-global-set  "C->" #'mc/mark-next-like-this)
(keymap-global-set  "C-<" #'mc/mark-previous-like-this)
(keymap-global-set  "C-c C-<" #'mc/mark-all-like-this)

;; magit config

(keymap-global-unset "C-c m")
(keymap-global-set "C-c m s" #'magit-status)
(keymap-global-set "C-c m l" #'magit-log)

;; Delete Line

(keymap-global-set "C-x l" #'kill-whole-line)

(provide 'acs-key)

;; Local Variables:
;; coding: utf-8
;; End:
