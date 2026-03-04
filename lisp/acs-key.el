;;; -*- lexical-binding: t; -*-


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


;; editor keyset

(keymap-global-set "C-=" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)
(keymap-global-set "C-c d" #'duplicate-line)


;; move text up&down

(keymap-global-set "M-<up>" #'move-text-up)
(keymap-global-set "M-<down>" #'move-text-down)


(keymap-global-set  "C-c m" #'tab-line-switch-to-next-tab)
(keymap-global-set  "C-c n" #'tab-line-switch-to-prev-tab)
(keymap-global-set  "C-c k" #'kill-current-buffer)
(keymap-global-set  "C-," #'rc/duplicate-line)



(provide 'acs-key)

;; Local Variables:
;; coding: utf-8
;; End:
