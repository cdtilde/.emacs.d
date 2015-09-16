(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "")
(setq initial-scratch-message "")


(defun startup-echo-area-message ()
  (message ""))
(display-time-mode)


(defconst *is-a-mac* (eq system-type 'darwin))

;;;(setq ring-bell-function 'ignore)
(setq query-replace-highlight t)
(fset 'yes-or-no-p 'y-or-n-p)
;;;(blink-cursor-mode 0)
;; (setq vc-follow-symlinks t)             ;
;; (savehist-mode 1)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(setq-default
 blink-cursor-mode 0
 bookmark-default-file (expand-file-name ".bookmarks.el" user-emacs-directory)
 buffers-menu-max-size 30
 case-fold-search t
 column-number-mode t
 ediff-split-window-function 'split-window-horizontally
 ediff-window-setup-function 'ediff-setup-windows-plain
 indent-tabs-mode nil
 make-backup-files nil
 mouse-yank-at-point t
 save-interprogram-paste-before-kill t
 scroll-preserve-screen-position 'always
 set-mark-command-repeat-pop t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil
 vc-follow-symlinks t
 visible-bell t)

(savehist-mode 1)


;; Load secret information
;;(load "~/.emacs.d/.emacs.secret")


;; Backup files
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))
(setq delete-old-versions t)


;; Scrolling
(setq scroll-step 1)
(setq scroll-conservatively 9999999)

;; Allow scrolling commands C-v, M-v during incremental search
(setq isearch-allow-scroll t)

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(provide 'init-basics)
