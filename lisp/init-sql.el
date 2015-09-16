;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;  SQL 
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'sql-tools)

(add-hook 'sql-mode-hook
          (lambda ()
            (modify-syntax-entry ?_  "w" sql-mode-syntax-table)            
            (toggle-truncate-lines t)))


(define-key sql-mode-map (kbd "C-c s l")         'send-latest-results-to-excel)
(define-key sql-mode-map (kbd "C-c s o")         'teradata-send-latest-results-to-data-mode)
(define-key sql-mode-map (kbd "C-c s r")         'send-region-to-excel)
(define-key sql-mode-map (kbd "C-c s d")         'teradata-format-as-date)
(define-key sql-mode-map (kbd "C-c s c")         'teradata-format-as-currency)
(define-key sql-mode-map (kbd "C-c s n")         'teradata-format-as-number)
(define-key sql-mode-map (kbd "C-c s p")         'teradata-format-as-percent)
(define-key sql-mode-map (kbd "C-c s b")         'make-new-sql-buffer)
(define-key sql-mode-map (kbd "C-c s s")         'sql-sort-column)
(define-key sql-mode-map (kbd "C-c s v")         'sql-column-calc)


(setq-default sql-input-ring-file-name
              (expand-file-name ".sql_history" user-emacs-directory))



(provide 'init-sql)
