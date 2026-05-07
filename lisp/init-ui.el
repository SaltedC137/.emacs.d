;;; init-ui.el --- settings for Emacs UI -*- lexical-binding: t -*-

;; Author: Cabins
;; Maintainer: Cabins
;; Version: 1.0
;; Package-Requires: ()
;; Homepage: https://github.com/cabins
;; Keywords:

;;; Commentary:
;; (c) Cabins Kong, 2020-2021

;;; Code:

;; adjust the fonts
(defun available-font (font-list &optional installed-fonts)
  "Get the first available font from FONT-LIST."
  (catch 'font
    (dolist (font font-list)
      (if (member font (or installed-fonts (font-family-list)))
	  (throw 'font font)))))

;;;###autoload
(defun cabins/setup-font ()
  "Font setup."

  (interactive)
  (let* ((installed-fonts (font-family-list))
         (efl '("Cascadia Code" "Source Code Pro" "JetBrains Mono" "Courier New" "Monaco" "Ubuntu Mono"))
	 (cfl '("楷体" "黑体" "STHeiti" "STKaiti"))
	 (cf (available-font cfl installed-fonts))
	 (ef (available-font efl installed-fonts)))
    (when ef
      (dolist (face '(default fixed-pitch fixed-pitch-serif variable-pitch))
	(set-face-attribute face nil :family ef :height 140)))
    (when cf
      (dolist (charset '(kana han cjk-misc bopomofo))
	(set-fontset-font t charset cf))
      (setq face-font-rescale-alist
	    (mapcar (lambda (item) (cons item 1.2)) cfl)))))

;; settings for daemon mode
(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(with-selected-frame frame
                  (toggle-frame-maximized)
		  (cabins/setup-font))))
  (add-hook 'after-init-hook
            (lambda ()
              (run-with-idle-timer
               0.2 nil
               (lambda ()
                 (toggle-frame-maximized)
                 (cabins/setup-font))))))


;; set mode-line

(require 'time)
(setopt display-time-format "%a-%b-%d %p %I:%M"
        display-time-day-and-date ""
        display-time-24hr-format nil)
(display-time-mode)



(setopt battery-mode-line-format "[%p%%] ")
(setopt battery-update-interval 300)
(display-battery-mode)




(provide 'init-ui)

;;; init-ui.el ends here
;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
