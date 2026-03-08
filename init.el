;;; -*- lexical-binding: t; -*-

(push (file-name-concat user-emacs-directory "lisp/") load-path)

(require 'acs-init)

(setq server-auth-dir (expand-file-name "server" user-emacs-directory
    server-name     "server.txt")

(setq file-name-coding-system 'chinese-gb18030)

;; Local Variables:
;; coding: utf-8
;; End: