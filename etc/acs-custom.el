;;; -*- lexical-binding: t; -*-

(defvar acs/c-appdata/ "~/.emacs.d/.appdata/"
  "存放杂七杂八的数据的目录 (绝对路径), 不包括配置文件.
有些数据 (e.g., 最近访问的文件名) 可能包含隐私信息.")

(add-hook 'before-init-hook
          (lambda ()
            (defvar acs/c-clang-format-path (or (executable-find "clang-format") "/usr/bin/clang-format"))
            (defvar acs/c-clang-path (or (executable-find "clang") "/usr/bin/clang"))
            (defvar acs/c-commonlisp-path (or (executable-find "sbcl") "/usr/bin/sbcl"))
            (defvar acs/c-email "saltedc137@gamil.com")
            (defvar acs/c-filename-coding 'chinese-gb18030)
            (defvar acs/c-os "MS-Windows 11")
            (defvar acs/c-python-path "c:/Users/SallyFace/AppData/Local/Programs/Python/Python313/python.exe")
            (defvar acs/c-shell-coding 'chinese-gb18030)
            (defvar acs/c-truename "小成")))

(defmacro acs/c:appdata/ (base &optional suffix seq-type &rest forms)


(declare (indent 3))
`(set ',base
      ,(if forms
            `(progn
              ,@forms)
          `(,(or seq-type
                'identity)
            ,(let ((&appdata/* (gensym "acs/")))
              `(let ((,&appdata/* (file-name-concat acs/c-appdata/
                                                    (concat (symbol-name ',base)
                                                            ,(if suffix
                                                                  `(concat ,(if (not (eq suffix '/))
                                                                                "."
                                                                              "")
                                                                          (symbol-name ',suffix))
                                                                "")))))
                  (prog1 ,&appdata/*
                    (make-directory (file-name-directory ,&appdata/*) "DWIM"))))))))

(provide 'acs/custom)

;; Local Variables:
;; coding: utf-8
;; End: