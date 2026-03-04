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

;; rc/insert-timestamp

(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "(%Y%m%d-%H%M%S)" nil t)))

(global-set-key (kbd "C-x p d") 'rc/insert-timestamp)

;; editor keyset

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)
(keymap-global-set "C-c d" #'duplicate-line)


;; move text up&down

(keymap-global-set "M-<up>" #'move-text-up)
(keymap-global-set "M-<down>" #'move-text-down)

;; tab line $ buffer control

(keymap-global-set  "C-c m" #'tab-line-switch-to-next-tab)
(keymap-global-set  "C-c n" #'tab-line-switch-to-prev-tab)
(keymap-global-set  "C-c k" #'kill-current-buffer)





(provide 'acs-key)

;; Local Variables:
;; coding: utf-8
;; End:
