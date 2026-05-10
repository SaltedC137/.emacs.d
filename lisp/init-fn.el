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


(defconst rc/frame-transparency 75)
(defun rc/toggle-transparency ()
  (interactive)
  (let ((frame-alpha (frame-parameter nil 'alpha)))
    (if (or (not frame-alpha)
            (= (cadr frame-alpha) 100))
        (set-frame-parameter nil 'alpha
                             `(,rc/frame-transparency
                               ,rc/frame-transparency))
      (set-frame-parameter nil 'alpha '(100 100)))))

;; format xml in region
(defun bf-pretty-print-xml-region (begin end)
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region begin end))
  (message "Ah, much better!"))

;; colorize compilation buffer
(defun rc/colorize-compilation-buffer ()
  (when (derived-mode-p 'compilation-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max)))))

(add-hook 'compilation-filter-hook 'rc/colorize-compilation-buffer)


(setq gdb-many-windows t)

;; astyle-buffer

(defun astyle-buffer (&optional justify)
  (interactive)
  (let ((saved-line-number(line-number-at-pos)))
    (shell-command-on-region
     (point-min)(point-max)
     "astyle --style=kr"
     nil
     t)
    (goto-line saved-line-number)))

;; compilation

(defun my/native-compile-all-config ()
  (interactive)
  (dolist (file (append
                 (list (expand-file-name "early-init.el" user-emacs-directory)
                       (expand-file-name "init.el" user-emacs-directory))
                 (directory-files (expand-file-name "lisp" user-emacs-directory)
                                  t "\\.el$")))
    (when (file-exists-p file)
      (byte-compile-file file)     ;; gengerate .elc
      (native-compile file)        ;; compile .eln
      (message "finish：%s" file))))



;; time

(defmacro +measure-time (&rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (message "%.06fs" (float-time (time-since time)))))


(provide 'init-fn)
;;;
