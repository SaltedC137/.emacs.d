;;; -*- lexical-binding: t; -*-

(push (file-name-concat user-emacs-directory "lisp/") load-path)

(require 'acs-init)

(setq server-auth-dir "C:/Users/SallyFace/.emacs.d/server"
    server-name     "server.txt")

(setq file-name-coding-system 'chinese-gb18030)

;; Local Variables:
;; coding: utf-8-unix
;; End: