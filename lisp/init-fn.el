;;; init-fn.el --- custom functions -*- lexical-binding: t -*-

(require 'ansi-color)

;; 复制当前行
(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (pos-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

;; 插入时间戳
(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "(%Y%m%d-%H%M%S)" nil t)))

;; 反向格式化段落（合并为一行）
(defun rc/unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces."
  (interactive)
  (let ((fill-column most-positive-fixnum))
    (fill-paragraph nil)))


(defun rc/rgrep-selected (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-min))))
  (rgrep (buffer-substring-no-properties beg end) "*" (pwd)))


(defconst rc/frame-transparency 85)
(defun rc/toggle-transparency ()
  (interactive)
  (let ((frame-alpha (frame-parameter nil 'alpha)))
    (if (or (not frame-alpha)
            (= (cadr frame-alpha) 100))
        (set-frame-parameter nil 'alpha
                             `(,rc/frame-transparency
                               ,rc/frame-transparency))
      (set-frame-parameter nil 'alpha '(100 100)))))

;; 格式化 XML
(defun bf-pretty-print-xml-region (begin end)
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region begin end))
  (message "Ah, much better!"))

;; 编译输出染色
(defun rc/colorize-compilation-buffer ()
  (when (derived-mode-p 'compilation-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max)))))

(add-hook 'compilation-filter-hook 'rc/colorize-compilation-buffer)


(setq gdb-many-windows t)

(provide 'init-fn)
;;;
