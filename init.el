;;; -*- lexical-binding: t; -*-

(push (file-name-concat user-emacs-directory "lisp/") load-path)

(require 'acs-init)

(setq server-auth-dir (expand-file-name "server" user-emacs-directory)
      server-name     "server")

(set-language-environment "UTF-8")
(setq default-process-coding-system '(utf-8 . utf-8))


;; Local Variables:
;; coding: utf-8
;; End:
