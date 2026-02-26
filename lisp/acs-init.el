;;; -*- lexical-binding: t; -*-

(defun acs/message-format (format-string)
  "在开头加上 \"acs: \" 前缀。"
  (declare (pure t)
           (indent 1))
  (format (propertize "acs: %s" 'face '(shadow italic))
          format-string))

(defmacro acs/buffer-eval-after-created (buffer-or-name &rest body)
  (declare (indent 1))
  (let ((&buffer-or-name (gensym "acs/buffer-eval-after-created-")))
    `(progn
       (setq ,&buffer-or-name ,buffer-or-name)
       (make-thread (lambda ()
                      (while (not (get-buffer ,&buffer-or-name))
                        (thread-yield))
                      ,@body)))))

(defmacro acs/save-cursor-relative-position-in-window (&rest body)
  "保持 cursor 在当前 window 中的相对位置. 像\'progn\'一样执行 BODY."
  (declare (indent 0))
  (let ((&acs--distance-from-window-top-to-point (gensym "acs/")))
    `(let ((,&acs--distance-from-window-top-to-point (- (line-number-at-pos nil t)
                                                          (save-excursion
                                                            (move-to-window-line 0)
                                                            (line-number-at-pos nil t)))))
      (prog1 (with-selected-window (selected-window)
              ,@body)
        (redisplay)
        (scroll-up-line (- (- (line-number-at-pos nil t)
                              (save-excursion
                                (move-to-window-line 0)
                                (line-number-at-pos nil t)))
                          ,&acs--distance-from-window-top-to-point))))))

(defmacro acs/prog1-let (varlist &rest body)
"(acs/prog1-let (...
                  (sym val))
...)                  ^^^ will be returned"
  (declare (indent 1))
  (let ((last-var (let ((last (car (last varlist))))
                    (if (atom last)
                        last
                      (car last)))))
    `(let ,varlist
      (prog1 ,last-var
        ,@body))))

(add-hook 'post-gc-hook
        (lambda ()
          (message (acs/message-format "%s")
                    (format-spec
                    #("%n GC (%ss total): %B VM, %mmin runtime"
                      7  9 (face bold)
                      26 28 (face bold))
                    `((?n . ,(format #("%d%s"
                                        0 2 (face bold))
                                      gcs-done
                                      (pcase (mod gcs-done 10)
                                        (1 "st")
                                        (2 "nd")
                                        (3 "rd")
                                        (_ "th"))))
                      (?m . ,(floor (time-to-seconds (time-since before-init-time)) 60))
                      (?s . ,(round gc-elapsed))
                      (?B . ,(cl-loop for memory = (memory-limit) then (/ memory 1024.0)
                                      for mem-unit across "KMGT"
                                      when (< memory 1024)
                                      return (format #("%.1f%c"
                                                        0 4 (face bold))
                                                      memory
                                                      mem-unit))))))))

;; 顺序应当是不重要的.

;; (require 'acs-elisp)    ; (find-file-other-window "./acs-elisp.el")
;; (require 'acs-tmp)      ; (find-file-other-window "./acs-tmp.el")
;; (require 'acs-org)      ; (find-file-other-window "./acs-org.el")
;; (require 'acs-abbrev)   ; (find-file-other-window "./acs-abbrev.el")
(require 'acs-themes)   ; (find-file-other-window "./themes/acs-themes.el")
;; (require 'acs-server)   ; (find-file-other-window "./acs-server.el")
;; (require 'acs-cc)       ; (find-file-other-window "./acs-cc.el")
;; (require 'acs-kbd)      ; (find-file-other-window "./acs-kbd.el")
(require 'acs-sh)       ; (find-file-other-window "./acs-sh.el")
;; (require 'acs-yas)      ; (find-file-other-window "./acs-yas.el")
;; (require 'acs-profile)  ; (find-file-other-window "./acs-profile.el")
;; (require 'acs-startup)  ; (find-file-other-window "./acs-startup.el")
(require 'acs-ui)       ; (find-file-other-window "./acs-ui.el")
;; (require 'acs-lib)      ; (find-file-other-window "./acs-lib.el")

(provide 'acs-init)

;; Local Variables:
;; coding: utf-8-unix
;; End: