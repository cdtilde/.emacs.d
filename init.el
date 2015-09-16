(defvar e/emacs-load-start (current-time))

(when (version<= emacs-version "24")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))


(when (version< emacs-version "23")
  (message "You are using emacs 22") 
  (setq user-emacs-directory  (directory-file-name (file-name-directory user-init-file))))


(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-basics)            ;;
(require 'init-benchmarking)      ;; Measure startup time
(require 'init-utils)

(when (not (version< emacs-version "24"))
  (require 'init-package)
  (require 'init-lisp)
  (require-package 'diminish)

  (require 'init-look)
  (require 'init-osx)               ;; OS X specific customizations
  (require 'init-sql)          
  (require 'init-windows)
  (require 'init-mouse)
  (require 'init-exec-path)
  (require 'init-editing)
  (require 'init-fileutils)
  ;;(require 'init-org-mode)
  (require 'init-cheatsheets)
  (require 'init-isearch)
  (require 'init-comint)
  (require 'init-gmail)
  (require 'init-helm)
  (require 'init-grep)
  (require 'init-hippie-expand)
  (require 'init-yasnippet)
  (require 'file-to-table)
  ;;----------------------------------------------------------------------------
  ;; Allow access from emacsclient
  ;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start)))
  




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;  KEYBINDINGS
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; SQL
(global-set-key (kbd "C-c f i")         'file-info)
(global-set-key (kbd "C-c f p")         'copy-current-path-to-system-clipboard)
(global-set-key (kbd "C-c s l")         'sql-start-local-mysql)
(global-set-key (kbd "C-c s m")         'sql-start-mysql-poc)
(global-set-key (kbd "C-c s 1")         (lambda () (interactive) (sql-start-mysql shard-mysql)))
(global-set-key (kbd "C-c s t")         'sql-start-teradata)

;; Themes, Look and Feel
(global-set-key (kbd "C-c t i")         'iawriter)
(global-set-key (kbd "C-c t w")         'wombat)
(global-set-key (kbd "C-c w f")         'flip-windows)
(global-set-key (kbd "C-=")             'text-scale-increase)
(global-set-key (kbd "C--")             'text-scale-decrease)

;; Misc
(global-set-key (kbd "C-c h c")         'cheatsheet-open)
(global-set-key (kbd "C-c c")           'compile)
(global-set-key (kbd "C-c m")           'magit-status)

;; Windows
(global-set-key (kbd "C-c w r")         'rotate-windows)
(global-set-key [142607065]             'ns-do-hide-others)         
(global-set-key (kbd "<C-s-268632070>") 'mac-toggle-max-window)
(global-set-key (kbd "<f10>")           'toggle-frame-maximized)

;; Text Editing & Movement
(global-set-key (kbd "C-o")             'open-previous-line) 
(global-set-key (kbd "M-o")             'open-next-line)
(global-set-key "%"		        'match-paren)               
;; (global-set-key (kbd "C-^")             'scroll-up-line)
;; (global-set-key (kbd "M-^")             'scroll-down-line)
(global-set-key (kbd "M-g")             'goto-line)
(global-set-key (kbd "C-c l")           'toggle-line-numbers)
(global-set-key (kbd "M-z")             'zap-up-to-char)
(global-set-key (kbd "M-Z")             'zap-to-char)
(global-set-key (kbd "C-c t w")         'transpose-words)
(global-set-key (kbd "C-c t s")         'transpose-sentences)
(global-set-key (kbd "C-c t l")         'transpose-lines)
(global-set-key (kbd "C-c t p")         'transpose-paragraphs)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(safe-local-variable-values (quote ((no-byte-compile t))))
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.googlemail.com")
 '(smtpmail-smtp-service 587))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

(add-to-list 'e/require-times (cons "emacs-load-start" (e/time-subtract-millis (current-time) e/emacs-load-start)) t)


