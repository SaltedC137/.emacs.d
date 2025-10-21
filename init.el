(let (
  (gc-cons-threshold most-positive-fixnum)
  (file-name-handler-alist nil))
  (require 'benchmark-init-modes)
  (require 'benchmark-init)
  (benchmark-init/activate)
  (menu-bar-mode -1)                                            
  (blink-cursor-mode 1)                                          
  (tool-bar-mode -1)                                             
  (scroll-bar-mode -1)                                                                                
  (show-paren-mode t)                                           
  (electric-pair-mode t)                                         
  (global-hl-line-mode -1)
  (global-font-lock-mode 1)
  (global-auto-revert-mode 1)                                     
  (delete-selection-mode 1)                                  
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq-default cursor-type 'bar)                               
  (setq                                    
        frame-title-mode t                                       
        font-lock-maximum-size 5000000
        frame-title-format "filename: %b"                            
        inhibit-splash-screen t                                   
        gnus-inhibit-startup-message t                          
        make-backup-files nil                                   
        backup-inhibited t                                      
        auto-save-mode nil                                       
        truncate-lines nil                                      
        transient-mark-mode t                                      
        global-font-lock-mode t                                  
        show-paren-style 'parenthesis                             
        require-final-newline t                                   
        track-eol t                                               
        c-default-style "awk"                                      
        initial-frame-alist (quote ((fullscreen . maximized)))    
  )
  (load-theme 'wheatgrass)
  (global-display-line-numbers-mode 1)
  
  ;; auto save code conf

  (defgroup auto-save nil
    "Auto save file when emacs idle."
    :group 'auto-save)
  
  (defcustom auto-save-idle 15
    "The idle seconds to auto save file."
    :type 'integer
    :group 'auto-save)
  
  (defcustom auto-save-slient nil
    "Nothing to dirty minibuffer if this option is non-nil."
    :type 'boolean
    :group 'auto-save)

  ;;set font
  
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Courier New" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
    charset
    (font-spec :family "Microsoft Yahei" :size 20)))

  (setq auto-save-default nil)
  
  (defun auto-save-buffers ()
    (interactive)
    (let ((autosave-buffer-list))
      (save-excursion
        (dolist (buf (buffer-list))
          (set-buffer buf)
          (if (and (buffer-file-name) (buffer-modified-p))
              (progn              
                (push (buffer-name) autosave-buffer-list)
                (if auto-save-slient                  
                    (with-temp-message ""
                      (basic-save-buffer))
                  (basic-save-buffer))
                )))
        (unless auto-save-slient
          (cond
          ((= (length autosave-buffer-list) 1)
            (message "# Saved %s" (car autosave-buffer-list)))
          ((> (length autosave-buffer-list) 1)
            (message "# Saved %d files: %s"
                    (length autosave-buffer-list)
                    (mapconcat 'identity autosave-buffer-list ", "))))))))
                    
  (defun auto-save-enable ()
    (interactive)
    (run-with-idle-timer auto-save-idle t #'auto-save-buffers))
  (auto-save-enable)
  (setq auto-save-slient t)

    (require'package) 
      (setq package-archives
        '(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
          ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
          ("org" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

  (setq package-check-signatur nil)
  (require'package) 
  (unless(bound-and-true-p package--initialized)
    (package-initialize)) 
  (unless package-archive-contents
    (package-refresh-contents))
  (add-to-list 'load-path (expand-file-name "packages" user-emacs-directory))
  (require 'init_third_package)
  (require 'simpc-mode)
  (add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
  (add-to-list 'load-path (expand-file-name "elpa/lsp-bridge" user-emacs-directory))
  (require 'yasnippet)  
  (yas-global-mode 1)
  (require 'lsp-bridge)
  (global-lsp-bridge-mode)
  (custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(benchmark-init neotree)))
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(which-key dap-mode lsp-mode orderless @ vertico benchmark-init neotree)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Courier New" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
