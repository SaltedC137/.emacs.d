;;; -*- lexical-binding: t; -*-

(require 'ansi-color)

(setopt initial-scratch-message
        (with-temp-buffer
            (insert-file-contents (expand-file-name "lisp/asset/AAyAUO_20240525150911.txt" user-emacs-directory))
            (ansi-color-apply (buffer-string))))

(setopt initial-major-mode 'lisp-interaction-mode)

(setq inhibit-startup-screen t
    initial-buffer-choice t)

(add-hook (intern (concat (symbol-name initial-major-mode) "-hook"))
        (lambda ()
            (when (string= (buffer-name) "*scratch*")
                (setq-local default-directory "D:/Tmp/"))))

;; 启动 Emacs 时 (通过 命令行参数) 一次性访问多个 (>2) 文件时, 不额外显示 Buffer Menu.
(setq inhibit-startup-buffer-menu t)

;; 只有设为自己在 OS 中的 username, 才能屏蔽启动时 echo area 的 “For information about GNU Emacs and the GNU system, type C-h C-a.”
(put 'inhibit-startup-echo-area-message  ; 需要如此 hack.
    'saved-value `(,(setq inhibit-startup-echo-area-message user-login-name)))


(add-hook 'post-command-hook
    (letrec ((acs/startup:indicator (lambda ()
        (remove-hook 'post-command-hook acs/startup:indicator)
        (let ((emacs-init-time (time-to-seconds (time-since before-init-time))))
        (message #("acs: 启动耗时 %.2fs"
                    10 15 (face bold))
                emacs-init-time)
        (when (daemonp)
            ;; 发出通知: Emacs 后台进程启动了.
            (let ((acs/startup:balloon-title "Emacs Daemon Launched")
                (acs/startup:balloon-body (format "Emacs 已经在后台启动了\n耗时 %.2f 秒"
                                                    emacs-init-time)))
            (pcase system-type
                ('windows-nt
                (advice-add 'w32-notification-notify :before
            (let* ((acs/startup:balloon-emitting-frame (let (before-make-frame-hook
                        window-system-default-frame-alist initial-frame-alist default-frame-alist
                        after-make-frame-functions server-after-make-frame-hook)
                    (make-frame-on-display (symbol-name initial-window-system)
                                            '((visibility . nil)))))
                    (acs/startup:balloon (with-selected-frame acs/startup:balloon-emitting-frame
                        (w32-notification-notify
                        :level 'info
                        :title acs/startup:balloon-title
                        :body acs/startup:balloon-body)))
                    (acs/startup:balloon-lock (make-mutex))
                    (acs/startup:message-closer (lambda ()
                            "关闭 ‘acs/startup:balloon’ 后, 顺便将其设为字符串 “closed”."
                            (with-selected-frame acs/startup:balloon-emitting-frame
                            (w32-notification-close acs/startup:balloon)
                            (setq acs/startup:balloon "closed")
                            (let (delete-frame-functions
                                    after-delete-frame-functions)
                                (delete-frame))))))
                (run-with-idle-timer 10 nil
                                        (lambda ()
                                        (with-mutex acs/startup:balloon-lock
                                            (unless (stringp acs/startup:balloon)
                                            (funcall acs/startup:message-closer)))))
                (lambda (&rest _)
                    (advice-remove 'w32-notification-notify "acs/startup:message-closer")
                    (with-mutex acs/startup:balloon-lock
                    (unless (stringp acs/startup:balloon)
                        (funcall acs/startup:message-closer))))) '((name . "acs/startup:message-closer"))))
                    (_
                (require 'notifications)
                (notifications-notify
                    :title acs/startup:balloon-title
                    :body acs/startup:balloon-body
                    :transient t)))))))))
        acs/startup:indicator)
    100)


(provide 'acs-start)

;; Local Variables:
;; coding: unicode
;; End: