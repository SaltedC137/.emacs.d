;;; -*- lexical-binding: t; -*-

;; (require 'ansi-color)

;; (defun my-centered-scratch-art (file-path)
;;   "读取文件，解析 ANSI 颜色，并根据窗口宽度居中 ASCII 艺术。"
;;     (with-temp-buffer
;;         (insert-file-contents file-path)
;;         (goto-char (point-min))
;;         (while (search-forward "\\e" nil t)
;;         (replace-match "\033"))
;;         (let* ((colored-text (ansi-color-apply (buffer-string)))
;;             (lines (split-string colored-text "\n"))
;;             (max-visible-width (apply #'max (mapcar #'length lines)))                                              
;;             (win-width (window-width))
;;             (pad-len (max 0 (/ (- win-width max-visible-width) 2)))
;;             (padding-string (make-string pad-len ?\s)))
            
;;         (mapconcat (lambda (line)
;;                     (concat padding-string line))
;;                     lines
;;                     "\n"))))
;; (setopt initial-scratch-message "")

;; ;; 并非有用
;; (defun acs/draw-scratch-art ()
;; "在当前窗口真正渲染后，在 scratch 绘制居中图像。"
;; (let ((win (get-buffer-window "*scratch*")))
;;     (when win
;;     (with-selected-window win
;;         (with-current-buffer "*scratch*"
;;         (when (= (buffer-size) 0)
;;             (insert (my-centered-scratch-art (expand-file-name "lisp/asset/AAyAUO_20240525150911.txt" user-emacs-directory)))
;;             (goto-char (point-min))))))))

;; (add-hook 'window-setup-hook #'acs/draw-scratch-art)

;; (add-hook 'server-after-make-frame-hook
;;         (lambda ()
;;             (run-with-timer 0.1 nil #'acs/draw-scratch-art)))

;; (setopt initial-major-mode 'lisp-interaction-mode)

;; (setq inhibit-startup-screen t
;;     initial-buffer-choice t)

;; (add-hook (intern (concat (symbol-name initial-major-mode) "-hook"))
;;         (lambda ()
;;             (when (string= (buffer-name) "*scratch*")
;;                 (setq-local default-directory "D:/Tmp/"))))


(defvar my-use-dashboard t
  "Enable dashboard.")

;; Set up dashboard
(use-package
  dashboard
  :ensure t
  :if my-use-dashboard
  :diminish dashboard-mode
  :bind
  (("<f2>" . open-dashboard)
   :map
   dashboard-mode-map
   ("q" . quit-dashboard)
   ("M-r" . restore-session))
  :hook (dashboard-mode . (lambda () (setq-local frame-title-format nil)))
  :init
  (setq dashboard-navigator-buttons
        `(((,(if (fboundp 'nerd-icons-octicon)
                 (nerd-icons-octicon "nf-oct-mark_github")
               )
            "GitHub"
            "Browse"
            (lambda (&rest _) (browse-url homepage-url)))
           (,(if (fboundp 'nerd-icons-octicon)
                 (nerd-icons-octicon "nf-oct-history")
               )
            "Restore"
            "Restore previous session"
            (lambda (&rest _) (persp-load-state-from-file)))
           (,(if (fboundp 'nerd-icons-octicon)
                 (nerd-icons-octicon "nf-oct-tools"))
            "Settings" "Open custom file"
            (lambda (&rest _) (find-file custom-file)))
           (,(if (fboundp 'nerd-icons-octicon)
                 (nerd-icons-octicon "nf-oct-download")
               )
            "Upgrade"
            "Upgrade packages synchronously"
            (lambda (&rest _) (package-upgrade-all nil))
            success))))
  (dashboard-setup-startup-hook)
  :config (defconst homepage-url "https://github.com/SaltedC137")

  ;; restore-session
  (defun restore-session ()
    "Restore the previous session."
    (interactive)
    (message "Restoring previous session...")
    (quit-window t)

    (message "Restoring previous session...done"))

  ;; recover layouts
  (defvar dashboard-recover-layout-p nil
    "Whether recovers the layout.")

  ;; open dashboard
  (defun open-dashboard ()
    "Open the *dashboard* buffer and jump to the first widget."
    (interactive)
    (if (length>
         (window-list-1)
         (if (and (fboundp 'treemacs-current-visibility)
                  (eq (treemacs-current-visibility) 'visible))
             2
           1))
        (setq dashboard-recover-layout-p t))

    (delete-other-windows)

    (dashboard-refresh-buffer))

  (defun quit-dashboard ()
    "Quit dashboard window."
    (interactive)
    (quit-window t)



    (when dashboard-recover-layout-p
      (cond
       ((bound-and-true-p tab-bar-history-mode)
        (tab-bar-history-back))
       ((bound-and-true-p winner-mode)
        (winner-undo)))
      (setq dashboard-recover-layout-p nil)))
  :custom-face
  (dashboard-heading ((t (:inherit (font-lock-string-face bold)))))
  (dashboard-items-face ((t (:weight normal))))
  (dashboard-no-items-face ((t (:weight normal))))
  :custom
  (dashboard-icon-type 'nerd-icons)
  (dashboard-page-separator "\n")
  (dashboard-path-style 'truncate-middle)
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-projects-backend 'projectile)
  (dashboard-path-style 'truncate-middle)
  (dashboard-path-max-length 60)
  (dashboard-startup-banner
   "~/.emacs.d/lisp/assets/GNUEmacs.png")
  (dashboard-image-banner-max-width 400)
  (dashboard-set-heading-icons t)
  ;; (dashboard-show-shortcuts nil)
  (dashboard-set-file-icons t)
  (dashboard-items '((recents . 10) (bookmarks . 5)(projects . 7)))
  (dashboard-startupify-list
   '(dashboard-insert-banner
     dashboard-insert-newline
     dashboard-insert-banner-title
     dashboard-insert-newline
     dashboard-insert-navigator
     dashboard-insert-newline
     dashboard-insert-init-info
     dashboard-insert-items
     dashboard-insert-newline
     dashboard-insert-footer)))

(setq initial-buffer-choice 'dashboard-open)
(add-hook 'server-after-make-frame-hook 'dashboard-open)

;; Display ugly ^L page breaks as tidy horizontal lines
(use-package page-break-lines
  :ensure t
  :defer t
  :diminish
  :hook (after-init . global-page-break-lines-mode)
  :config (dolist (mode '(dashboard-mode emacs-news-mode))
            (add-to-list 'page-break-lines-modes mode)))

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
;; coding: utf-8
;; End:
