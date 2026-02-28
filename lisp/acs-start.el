;;; -*- lexical-binding: t; -*-



(setopt initial-scratch-message #("\s\n"  ; 它会先被 ‘substitute-command-keys’ 处理.
                                  0 1 (display #("\
             *     ,MMM8&&&.            *
                  MMMM88&&&&&    .
                 MMMM88&&&&&&&
     *           MMM88&&&&&&&&
                 MMM88&&&&&&&&
                 'MMM88&&&&&&'
                   'MMM8&&&'      *
           /\\/|_      __/\\\\
          /    -\\    /-   ~\\  .              '
          \\    = Y =T_ =   /
           )==*(`     `) ~ \\
          /     \\     /     \\
          |     |     ) ~   (
         /       \\   /     ~ \\
         \\       /   \\~     ~/
  ____/\\_/\\__  _/_/\\_/\\__~__/_/\\_/\\_/\\_/\\_/\\_
  |  |  |  | ) ) |  |  | ((  |  |  |  |  |  |
  |  |  |  |( (  |  |  |  \\\\ |  |  |  |  |  |
  |  |  |  | )_) |  |  |  |))|  |  |  |  |  |
  |  |  |  |  |  |  |  |  (/ |  acs/000000  |
  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
"  ; originally created by Joan G. Stark
                                                13  14  #1=(face (:foreground "LawnGreen"))  ; Leaf
                                                40  41  #1#
                                                75  76  #1#
                                                113 114 #1#
                                                235 236 #1#
                                                295 296 #1#
                                                310 311 #1#
                                                19  28  #2=(face (:foreground "yellow2"))  ; Moon
                                                60  71  #2#
                                                94  107 #2#
                                                125 138 #2#
                                                156 169 #2#
                                                187 200 #2#
                                                220 229 #2#
                                                248 264 #3=(face (:foreground "VioletRed1"))  ; Cat
                                                275 293 #3#
                                                322 491 #3#
                                                502 509 #3#
                                                513 521 #3#
                                                551 554 #3#
                                                563 565 #3#
                                                596 599 #3#
                                                610 612 #3#
                                                643 646 #3#
                                                657 659 #3#
                                                702 704 #3#
                                                708 718 #4=(face (italic shadow))  ; Signature
                                                494 502 #5=(face (:foreground "burlywood3"))  ; Fence
                                                509 514 #5#
                                                521 537 #5#
                                                540 550 #5#
                                                555 562 #5#
                                                567 583 #5#
                                                586 596 #5#
                                                601 608 #5#
                                                613 629 #5#
                                                632 642 #5#
                                                647 657 #5#
                                                659 675 #5#
                                                678 700 #5#
                                                705 706 #5#
                                                720 767 #5#
                                                )))
        initial-major-mode 'lisp-interaction-mode)

(setq inhibit-startup-screen t
    inhibit-buffer-choice t)

(add-hook (intern (concat (symbol-name initial-major-mode) "-hook"))
        (lambda ()
            (when (string= (buffer-name) "*scratch*")
                (setq-local default-directory "D:/Tmp/"))))

;; 启动 Emacs 时 (通过 命令行参数) 一次性访问多个 (>2) 文件时, 不额外显示 Buffer Menu.
(setq inhibit-startup-buffer-menu t)

;; 只有设为自己在 OS 中的 username, 才能屏蔽启动时 echo area 的 “For information about GNU Emacs and the GNU system, type C-h C-a.”
(put 'inhibit-startup-echo-area-message  ; 需要如此 hack.
    'saved-value `(,(setq inhibit-startup-echo-area-message user-login-name)))




(provide 'acs-start)

;; Local Variables:
;; coding: utf-8-unix
;; End: