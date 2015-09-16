
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.")

;; Mark and parentheses
(delete-selection-mode 1)   ;; With region active, type to delete entire region
(transient-mark-mode t)
(column-number-mode 1)
(show-paren-mode t)
(setq show-paren-style 'mixed)


;; Indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq python-indent-offset 4)

(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 2)))

(add-hook 'sql-mode-hook (lambda ()
                           (setq c-basic-offset 2)))



;; Behave like vi's o command
(defun open-next-line (arg)
  "Move to the next line and then opens a line.
    See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

(defun open-previous-line (arg)
  "Open a new line before the current one. 
     See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

;; Autoindent open-*-lines
(defvar newline-and-indent t
  "Modify the behavior of the open-*-line functions to cause them to autoindent.")



(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	            (t (self-insert-command (or arg 1)))))

(setq viper-mode t)
(require 'viper)
(global-set-key (kbd "M-f") 'viper-forward-word)
(global-set-key (kbd "M-b") 'viper-backward-word)
(global-set-key (kbd "M-F") 'viper-forward-Word)
(global-set-key (kbd "M-B") 'viper-backward-Word)
(viper-go-away)



(provide 'init-editing)
