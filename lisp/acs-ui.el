;;; -*- lexical-binding: t; -*-


'(overline-margin 0 nil () "上划线的高度+宽度")
'(mouse-highlight t nil () "当鼠标位于clickable位置时,高亮此处的文本")

(require 'acs-themes)

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
            ;; ‘indent-guide’ 删了.
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

;;; Tool Bar:

(setq tool-bar-style 'both)
(tool-bar-mode -1)

;;; Tab Bar:

(with-eval-after-load 'tab-bar
    (setq tab-prefix-map nil))

;;; Tab Line:

(setq tab-line-close-button-show nil
    tab-line-new-button-show nil
    ;; 关闭 tab-line-name 之间默认的空格.
    tab-line-separator "")
;; Tab line 
(setopt tab-line-switch-cycling nil)
(setq-default tab-line-format `(:eval (mapcar ',(prog1 (lambda (buffer-tab-line-name)
                                                (concat (let ((-buffer-icon (when (get-buffer buffer-tab-line-name)
                                                                                (with-current-buffer buffer-tab-line-name
                                                                                (all-the-icons-icon-for-buffer)))))
                                                        (if (stringp -buffer-icon)
                                                                -buffer-icon
                                                                ""))
                                                        buffer-tab-line-name))
                                        (require 'all-the-icons))
                                        (tab-line-format))))

(global-tab-line-mode)

;;; Window:

(setopt window-resize-pixelwise t)

(setopt window-min-height 4
        window-min-width  1)

;; 不需要高亮_当前行_, 因为_当前行号_是高亮的.
(global-hl-line-mode -1)

;;; Text Area:

;; 除了当前选中的 window, 还 高亮 non-selected window 的 active region.
(setopt highlight-nonselected-windows t)

;; 渲染成对的单引号时, 尽可能使用 ‘curve’ 这种样式, 退而求此次地可以使用 `grave' 这种样式.
(setopt text-quoting-style nil)

;;; Fringe:

(set-fringe-mode '(0 . nil))  ; Right-only.

(setopt display-line-numbers-type t  ; 启用绝对行号.
        ;; 开启 relative/visual 行号时, 当前行仍然显示 absolute 行号.
        display-line-numbers-current-absolute t)
(setopt display-line-numbers-widen t  ; 无视 narrowing, 行号从 buffer 的起始点计算.
        ;; 动态改变为行号预留的列数.
        display-line-numbers-width nil
        ;; 行号占用的列数可以动态减少.
        display-line-numbers-grow-only nil)
(setopt line-number-display-limit nil  ; 当 buffer 的 size 太大时是否启用行号, 以节约性能.
        ;; 单行太长也会消耗性能用于计算行号, 因此,
        ;; 如果当前行附近的行的平均宽度大于该值, 则不计算行号.
        line-number-display-limit-width most-positive-fixnum)
;; 每 10 行就用 ‘line-number-major-tick’ 高亮一次行号.
(setopt display-line-numbers-major-tick 10)
(global-display-line-numbers-mode t)

;; 若开启, buffer 尾行之后的区域的右流苏区域会显示密集的刻度线.
(setopt indicate-empty-lines nil)
(setopt overflow-newline-into-fringe t)

;; 启用 word-wrap 时在换行处显示 down-arrow.
(setopt visual-line-fringe-indicators '(nil down-arrow))

;; 控制是否在 fringe 所在的区域上显示首尾指示符 (window 的四个边角区域).
(setopt indicate-buffer-boundaries nil)

;;; Scroll Bar:
(setopt scroll-bar-mode 'right)

;; 滚动条落至底部 (overscrolling) 时的行为.
(setopt scroll-bar-adjust-thumb-portion nil)

(setq-default scroll-bar-width 28)


;;; Mode Line:

;; Face ‘mode-line-inactive’ for non-selected window’s mode line.
(setopt mode-line-in-non-selected-windows t)
(setopt mode-line-compact nil)  ; 不要设 t, 否则即使有多余的空间, 它也倾向于挤在一起.
(setopt mode-line-right-align-edge 'window)  ; 与 window 的边缘对齐.

(setopt doom-modeline-display-misc-in-all-mode-lines t  ; 没看出有什么区别, 先设 t, 继续观察...
        doom-modeline-minor-modes nil)
(setopt doom-modeline-bar-width 3  ; 左侧 小竖条 (装饰品) 的 宽度.
        ;; 尽可能地窄.
        doom-modeline-height 32
        ;; 即使当前窗口宽度很小, 也尽量显示所有信息.
        doom-modeline-window-width-limit nil)
(doom-modeline-mode)

(setopt mode-line-percent-position nil
        doom-modeline-percent-position mode-line-percent-position)

(size-indication-mode)  ; 在 mode line 上显示 buffer 大小.
(setq mode-line-column-line-number-mode-map ())  ; 使某些可点击文本不作出应答.

;; 当 buffer 对应的文件名相同时, 在 buffer 名字之前补全文件的路径, 使 buffer 的名字互异.
(setopt uniquify-buffer-name-style 'forward
        ;; 当‘uniquify-buffer-name-style’的设置涉及补全文件路径时, 保留显示路径名之间相同的部分.
        uniquify-strip-common-suffix t)

(line-number-mode -1)  ; Mode line 上不要显示行号, 因为 window 左边缘已经显示行号了.
;; 从 1 开始计数.
(setopt mode-line-position-column-format '("C%C")
        doom-modeline-column-zero-based nil)
(column-number-mode)

;;; End of Line
(setopt eol-mnemonic-unix " LF "
        eol-mnemonic-mac  " CR "
        eol-mnemonic-dos  " CRLF "
        eol-mnemonic-undecided " ?EOL ")

(setopt mode-line-process t)  ; E.g., ‘Shell :run’.

;;; Display Time Mode

(require 'time)
(setopt display-time-format "%a%b%d%p%I:%M"
        display-time-day-and-date "若‘display-time-format’是 nil 则使用默认的日期显示方式"
        display-time-24hr-format nil)
(setq display-time-mail-icon (find-image '(
                                           (:type xpm :file "letter.xpm" :ascent center)
                                           (:type pbm :file "letter.pbm" :ascent center)
                                           ))
      ;; 使用由 ‘display-time-mail-icon’ 指定的 icon, 如果确实找到了这样的 icon 的话;
      ;; 否则 使用 Unicode 图标.
      display-time-use-mail-icon display-time-mail-icon

      ;; 是否检查以及如何检查邮箱, 采用默认策略 (i.e., 系统决定).
      display-time-mail-file nil
      ;; 该目录下的所有非空文件都被当成新送达的邮件.
      display-time-mail-directory nil)
(setopt display-time-default-load-average 0  ; 显示过去 1min 的平均 CPU 荷载.
        ;; 当 CPU 荷载 >= 0 时, 显示 CPU 荷载.
        display-time-load-average-threshold 0)
(setopt display-time-interval 60)
(display-time-mode)
(advice-add 'display-time-next-load-average :before-until ; 使可点击文本 (CPU 负荷) 不作出应答.
            (lambda ()
              (and (called-interactively-p 'any)
                   (when (listp last-command-event)
                     (eq (car last-command-event) 'mouse-2)))))

(setopt which-func-maxout most-positive-fixnum
        which-func-modes t  ; 服务任何 mode.
        ;; 不知道当前函数是什么时的显示词.
        which-func-unknown "?")
(which-function-mode)  ; 依赖 ‘imenu’ 提供的数据, 在 modeline 上显示当前 defun 名.

;;; Display Battery Mode
(setopt battery-mode-line-format "[%p%%] ")
(setopt battery-update-interval 300)  ; 秒钟.
(display-battery-mode)

(setopt keycast-mode-line-format "%k%c%r "
        keycast-mode-line-insert-after (cl-first mode-line-format)
        keycast-mode-line-remove-tail-elements nil)

(provide 'acs-ui)

;; Local Variables:
;; coding: utf-8-unix
;; End: