;;; -*- lexical-binding: t; -*-


'(overline-margin 0 nil () "上划线的高度+宽度")
'(mouse-highlight t nil () "当鼠标位于clickable位置时,高亮此处的文本")



(add-hook 'emacs-startup-hook  ; 在调用 ‘frame-notice-user-settings’ 前运行.
        (lambda ()
        ;; 摘编自 Centaur Emacs, 用于解决 字体 问题.
        (let* ((font       "Maple Mono NF CN:slant:weight=medium:width=normal:spacing")
                (attributes (font-face-attributes font)                                   )
                (family     (plist-get attributes :family)                                ))
            ;; Default font.
            (apply #'set-face-attribute
                    'default nil
                    attributes)
            ;; For all Unicode characters.
            (set-fontset-font t 'symbol
                            (font-spec :family "Segoe UI Symbol")
                            nil 'prepend)
            ;; Emoji 🥰.
            (set-fontset-font t 'emoji
                            (font-spec :family "Segoe UI Emoji")
                            nil 'prepend)
            ;; For Chinese characters.
            (set-fontset-font t '(#x4e00 . #x9fff)
                            (font-spec :family family)))

        (custom-set-faces
            '(cursor
            ((t . (:background "chartreuse")))
            nil
            "该 face 仅有 ‘:background’ 字段有效")
            '(tooltip
            ((t . ( :height     100
                    :background "dark slate gray"))))
            '(line-number
            ((t . ( :slant  italic
                    :weight light))))
            `(line-number-major-tick
            ((t . ( :foreground ,(face-attribute 'line-number :foreground)
                    :background ,(face-attribute 'line-number :background)
                    :slant      italic
                    :underline  t
                    :weight     light)))
            nil
            "指定倍数的行号;除此以外,还有‘line-number-minor-tick’实现相同的功能,但其优先级更低")
            '(line-number-current-line
            ((t . ( :slant  normal
                    :weight black))))
            '(window-divider
            ((t . (:foreground "SlateBlue4"))))
            ;; ;; 我把 ‘indent-guide’ 删了.
            ;; (setq indent-guide-recursive t
            ;;       indent-guide-char "\N{BOX DRAWINGS LIGHT VERTICAL}")
            '(indent-guide-face
            ((t . (:foreground "dark sea green"))))
            '(fill-column-indicator
            ((t . ( :inherit shadow
                    :height  unspecified  ; 使其跟随整体缩放.
                    :background "black"
                    :foreground "yellow")))))))


(add-to-list 'default-frame-alist '(left  . 301))
(add-to-list 'default-frame-alist '(width . 66))
(add-to-list 'default-frame-alist '(top    . 121))
(add-to-list 'default-frame-alist '(height . 26))

(keymap-global-set "C-c z"
                (lambda ()
                    (interactive)
                    (set-frame-parameter nil 'fullscreen nil)
                    (let-alist default-frame-alist
                    (set-frame-position nil .left .top)
                    (set-frame-size nil .width .height))))

(setopt frame-background-mode nil)

(setopt frame-resize-pixelwise t)


(add-to-list 'default-frame-alist
             `(,(pcase system-type
                  ("TODO: Dunno how to test whether the platform supports this parameter." 'alpha-background)
                  (_ 'alpha))
               . 75))


;; +-----------------------------------------+
;; |‘stored?’ => nil.  Daemon is initialized.|
;; |‘getter’ is in ‘server-*-make-*-hook’.   |
;; +---------------------+-------------------+
;;                       |
;;  No frame on desktop. | Let’s _make_ one.
;;                       V                          Because ‘stored?’ is t, the frame to make will
;; +------------------------------------------+     use the parameters of the last frame which is deleted
;; |Run ‘getter’ in ‘server-*-make-*-hook’:   |<-------------------------------------------+
;; |‘getter’ itself is removed from the hook; |     when Emacs runs ‘server-*-make-*-hook’.|
;; |‘setter’ is in ‘delete-*-functions’.      |                                            |
;; +------------------------------------------+                                            |
;;  Let’s _make_ more frames.                                                              |
;;  Either ‘getter’ or ‘setter’ won’t run.                                                 |
;;           |                                                                             |
;;           | Let’s _delete_ one frame.                          No frame on desktop now. | Let’s _make_ one.
;;           V                                                                             |
;; +-------------------------------------+                             +-------------------+-----------------+
;; |Run ‘setter’ in ‘delete-*-functions’:| Let’s _delete_ the last one |Run ‘setter’ in ‘delete-*-functions’:|
;; |nothing will happend because the     +---------------------------->|frame parameters will be stored;     |
;; |frame to be deleted is not the only  |     frame on the desktop.   |now ‘stored?’ => t; ‘setter’ itself  |
;; |one frame on the desktop.            |                             |is removed from the hook; ‘getter’ is|
;; ++------------------------------------+                             |in ‘server-*-make-*-hook’            |
;;  |                                   ^                              +-------------------------------------+
;;  |Let’s _delete_ frames until there’s|
;;  +-----------------------------------+
;;   only one frame left on the desktop.


( add-hook 'server-after-make-frame-hook
        (let ((acs/ui:frame-size&position `(
        ,(cons 'top 0) 
        ,(cons 'left 0) 
        ,(cons 'width 0) 
        ,(cons 'height 0)
        ;; ‘fullscreen’放最后, 以覆盖‘width’&‘height’.
        ,(cons 'fullscreen nil)))
            acs/ui:frame-size&position-stored?)
        (letrec ((acs/ui:frame-size&position-getter (lambda ()
                (when acs/ui:frame-size&position-stored?
                    (dolist (parameter-value acs/ui:frame-size&position)
                    (set-frame-parameter nil (car parameter-value) (cdr parameter-value))))
                (remove-hook 'server-after-make-frame-hook acs/ui:frame-size&position-getter)
                    ( add-hook 'delete-frame-functions       acs/ui:frame-size&position-setter)))
            (acs/ui:frame-size&position-setter (lambda (frame-to-be-deleted)
                (when (length= (frames-on-display-list) 1)
                ;; MS-Windows 上的 “最小化窗口” 似乎就只是把窗口挪到屏幕之外, 所以得先把它挪回来.
                (make-frame-visible frame-to-be-deleted)
                (dolist (parameter-value acs/ui:frame-size&position)
                    (setcdr parameter-value (frame-parameter frame-to-be-deleted (car parameter-value))))
                (setq acs/ui:frame-size&position-stored? t)
                (remove-hook 'delete-frame-functions       acs/ui:frame-size&position-setter)
                ;; 当需要调用该 lambda 表达式时, 必然没有除此以外的其它frame了,
                ;; 因此之后新建的 frame 必然是 server 弹出的, 所以此处无需使用‘after-make-frame-functions’.
                ( add-hook 'server-after-make-frame-hook acs/ui:frame-size&position-getter)))))
    acs/ui:frame-size&position-getter)))

;; 分割线
(setopt window-divider-default-places      'right-only  
    window-divider-default-right-width 12)
(window-divider-mode)

;; Frame Title 





;;; Menu Bar:

(keymap-global-unset "<menu-bar> <file> <close-tab>")
(keymap-global-unset "<menu-bar> <file> <delete-this-frame>")
(keymap-global-unset "<menu-bar> <file> <exit-emacs>")
(keymap-global-unset "<menu-bar> <file> <kill-buffer>")
(keymap-global-unset "<menu-bar> <file> <make-frame>")
(keymap-global-unset "<menu-bar> <file> <make-tab>")
(keymap-global-unset "<menu-bar> <file> <new-window-below>")
(keymap-global-unset "<menu-bar> <file> <new-window-on-right>")
(keymap-global-unset "<menu-bar> <file> <one-window>")
(keymap-global-unset "<menu-bar> <file> <open-file>")
(keymap-global-unset "<menu-bar> <file> <save-buffer>")

(keymap-global-unset "<menu-bar> <edit> <copy>")
(keymap-global-unset "<menu-bar> <edit> <cut>")
(keymap-global-unset "<menu-bar> <edit> <mark-whole-buffer>")
(keymap-global-unset "<menu-bar> <edit> <paste>")
(keymap-global-unset "<menu-bar> <edit> <undo-redo>")
(keymap-global-unset "<menu-bar> <edit> <undo>")

(keymap-global-unset "<menu-bar> <options> <cua-mode>")
(keymap-global-unset "<menu-bar> <options> <customize> <customize-saved>")
(keymap-global-unset "<menu-bar> <options> <save>")
(keymap-global-unset "<menu-bar> <options> <uniquify>")
(keymap-global-unset "<menu-bar> <options> <save-place>")
(keymap-global-unset "<menu-bar> <options> <transient-mark-mode>")
(keymap-global-unset "<menu-bar> <options> <highlight-paren-mode>")

(keymap-global-unset "<menu-bar> <buffer> <select-named-buffer>")

(keymap-global-unset "<menu-bar> <tools> <browse-web>")
(keymap-global-unset "<menu-bar> <tools> <gnus>")


;;; Imenu
(setopt imenu-auto-rescan t
        ;; Buffer 很大, ‘imenu’你忍一下.
        imenu-auto-rescan-maxout most-positive-fixnum
        ;; 超过 这几秒 就算了.
        imenu-max-index-time (* 0.3 idle-update-delay))
(setopt imenu-sort-function #'imenu--sort-by-name)
;; (add-hook 'XXX-mode-hook #'imenu-add-menubar-index)

(keymap-global-unset "<menu-bar> <help-menu> <about-emacs>")
(keymap-global-unset "<menu-bar> <help-menu> <about-gnu-project>")
(keymap-global-unset "<menu-bar> <help-menu> <describe-copying>")
(keymap-global-unset "<menu-bar> <help-menu> <describe-no-warranty>")
(keymap-global-unset "<menu-bar> <help-menu> <emacs-manual>")
(keymap-global-unset "<menu-bar> <help-menu> <emacs-tutorial>")
(keymap-global-unset "<menu-bar> <help-menu> <external-packages>")
(keymap-global-unset "<menu-bar> <help-menu> <getting-new-versions>")
(keymap-global-unset "<menu-bar> <help-menu> <more-manuals> <order-emacs-manuals>")

(provide 'acs-ui)

;; Local Variables:
;; coding: utf-8-unix
;; End: