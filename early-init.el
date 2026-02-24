;;; -*- lexical-binding: t; -*-

(push (file-name-concat user-emacs-directory "lisp/") load-path)

(add-hook 'window-setup-hook
        (let ((acs--performance-impactful-variables 
            (list
            (vector 'gc-cons-threshold            most-positive-fixnum 'acs--expected-value)
            (vector 'gc-cons-percentage           1.0                  'acs--expected-value)
            (vector 'frame-inhibit-implied-resize t                    'acs--expected-value)
            (vector 'file-name-handler-alist      nil                  'acs--expected-value)
            (vector 'inhibit-menubar-update       t                    'acs--expected-value)
            (vector 'inhibit-redisplay            t                    'acs--expected-value)
        )))

(mapc (lambda (variable-new-expected)
        (let ((acs--variable-name  (aref variable-new-expected 0)))
        (when (eq (aref variable-new-expected 2) 'acs--expected-value)
            (when (boundp acs--variable-name)
            (aset variable-new-expected 2 (default-toplevel-value acs--variable-name))))
        (set-default-toplevel-value acs--variable-name (aref variable-new-expected 1)))) acs--performance-impactful-variables)

(lambda ()
  (make-thread (lambda ()
                (sleep-for 1)
                (require 'seq)
                (seq-doseq (variable-new-expected acs--performance-impactful-variables)
                    (set-default-toplevel-value (aref variable-new-expected 0) (aref variable-new-expected 2))))))))

(setq force-load-messages t)
(setopt load-prefer-newer nil)

(require 'acs-early-init)  ; (find-file-other-window "./lisp/acs-early-init.el")

;; Local Variables:
;; coding: utf-8-unix
;; End: