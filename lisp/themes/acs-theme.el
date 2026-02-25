;;; -*- lexical-binding: t; -*-

;; See (info "(emacs) Custom Themes")
;;
;;      Setting or saving Custom themes actually works by customizing
;;   ‘custom-enabled-themes’.  Its value is a list of Custom theme
;;   names (as Lisp symbols, e.g., ‘tango’).
;;
;;      If settings from two different themes overlap, the theme occurring
;;   earlier in ‘custom-enabled-themes’ takes precedence.
;;
;;      You can enable a specific Custom theme by typing [M-x ‘load-theme’].
;;   This prompts for a theme name, _loads_ the theme from the theme file,
;;   and _enables_ it.  If a theme file has been loaded before, you can
;;   enable the theme without loading its file by typing [M-x ‘enable-theme’].
;;   To disable a Custom theme, type [M-x ‘disable-theme’].

(setq custom-theme-directory (file-name-concat user-emacs-directory
                                            "lisp/themes/")
    custom-safe-themes t)

;; acs’s Themes:
(require-theme 'acs-light-theme)  ; (find-file-other-window "./acs-light-theme.el")
(require-theme 'acs-dark-theme)   ; (find-file-other-window "./acs-dark-theme.el")

(require-theme 'modus-vivendi-theme)
(enable-theme 'modus-vivendi)
(set-face-background 'help-key-binding (face-background 'default))

(provide 'acs-themes)

;; Local Variables:
;; coding: utf-8-unix
;; no-byte-compile: nil
;; End: