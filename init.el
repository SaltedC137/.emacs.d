;;; init.el --- the entry of emacs config -*- lexical-binding: t -*-

;; Author: Cabins
;; Maintainer: Cabins
;; Version: 1.0
;; Homepage: https://github.com/cabins

;;; Commentary:
;; (c) Cabins Kong, 2020-2021


;;benchmark

;;; Code:
(setq default-directory "~/")

;; Update the load-path
(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp/")))


;; Settings for Emacs 28+
(when (and (fboundp 'native-comp-available-p)
	       (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors nil
	    comp-deferred-compilation t
	    package-native-compile t)
  (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache" user-emacs-directory)))

;; consts defination
;; (defconst *is-mac* (eq system-type 'darwin) "Apple macOS platform.")
;; (defconst *is-linux* (eq system-type 'gnu/linux) "GNU/Linux platform.")
;; (defconst *is-windows* (memq system-type '(cygwin windows-nt ms-dos)) "Windows / DOS.")

;; Load theme immediately after package initialization to avoid flicker
(require 'package)
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

(setq custom-safe-themes t)
(load-theme 'monokai-pro)

;; settings for independent packages and etc.
(let ((load-prefer-newer t))
  (require 'init-fn)
  (require 'init-system)
  (require 'init-elpa)
  (require 'init-package)
  (require 'init-builtin)
  (require 'init-ide)
  (require 'init-ui)
  (require 'init-kbd)
  (require 'init-dash))

;; load custom file at last
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (let ((load-prefer-newer t))
    (load custom-file)))

(provide 'init)

;;; init.el ends here
;; Local Variables:
;; byte-compile-warnings: (not obsolete free-vars unresolved)
;; End:
