
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;  HELM
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require-package 'helm)                  ;

;; ;;(setq helm-idle-delay 0.1)
;; ;;(setq helm-input-idle-delay 0.1)
;; (setq helm-locate-command (concat "~/.dotfiles/locate-with-mdfind" " %s %s"))

;; (add-to-list 'load-path "~/.emacs.d/sql-info")

;; (defun imenu-elisp-sections ()
;;   (setq imenu-prev-index-position-function nil)
;;   (add-to-list 'imenu-generic-expression '("Sections" "^;;\\ \\ \\(.+\\)$" 1) t))

;; (add-hook 'emacs-lisp-mode-hook 'imenu-elisp-sections)

(global-set-key (kbd "C-x f")           'helm-for-files)
(global-set-key (kbd "C-c h i")         'helm-imenu)


(provide 'init-helm)
