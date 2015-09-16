;;; sql-tools.el --- Emacs functions for interacting with SQL buffers
;;

;;; License:
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;      http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;; Commentary:
;; 
;; To use this file, put something like the following in your
;; ~/.emacs:
;;
;; (add-to-list 'load-path "/directory/containing/sql-tools/")
;; (require 'sql-tools)
;;


;;; Code:
(require 'sql)

(defun make-new-sql-buffer ()
  (interactive)
  (setq mybuffername (concat "~/Documents/SQL History/"
			     (format-time-string "%Y-%m-%d - %H-%M-%S")
			     ".sql"))
  (find-file-other-window mybuffername)
  (sql-set-sqli-buffer-generally))
  

(defun sql-start-session (script product)
  "Connect to a database, open a SQL window and split horizontally.
   ARG is the shell script that will be executed to create the SQL session."
  (sql-set-product product)
  (cond ((string= product "db2")
	 (setq sql-db2-program script)
	 (sql-db2))
	((string= product "sqlite")
	 (setq sql-sqlite-program script)
	 (sql-sqlite))
	((string= product "mysql")
	 (setq sql-mysql-program script)
	 (sql-mysql)))
  (switch-to-buffer "*SQL*")
  (toggle-truncate-lines 1)
  (if (delq nil (mapcar (lambda (arg)
           (cond ((string= (buffer-local-value 'major-mode (get-buffer arg)) "sql-mode")
                  t)))
         (buffer-list)))
      (setq sql-buffer "*SQL*")
    (make-new-sql-buffer))
  (sql-set-sqli-buffer-generally))


    
      ;; (progn
      ;;   (setq mybuffername (concat "~/Documents/SQL History/"
      ;;   		     (format-time-string "%Y-%m-%d - %H-%M-%S")
      ;;   		     ".sql"))
      ;;   (find-file-other-window mybuffername)
      ;;   (setq sql-buffer "*SQL*"))))







(defun mark-current-statement (arg)
  (interactive "p")
  (let ((case-fold-search t)
        (beg (point-min))
        (end (point-max))
        (found nil))
    (end-of-line)
    (while (and (not found) (search-backward-regexp "SELECT\\|UPDATE\\|DELETE\\|INSERT"  nil t 1))
      (if (and (not (nth 8 (syntax-ppss)))
               (not (nth 3 (syntax-ppss))))
          (setq found t)))
    (if found (setq beg (point)))
    (goto-char beg)    
    (setq found nil)
    (while (and (not found) (search-forward-regexp ";"  nil t 1))
      (if (and (not (nth 8 (syntax-ppss)))
               (not (nth 3 (syntax-ppss))))
          (setq found t)))
    (if found (setq end (point)))
    (push-mark beg)
    (if (eq arg 1)
        (setq mark-active t))
    ))








    



(defun sql-start-teradata ()
    (interactive)
    (sql-start-session "~/.sql-scripts/bteq" "db2"))


(defun sql-start-mysql-poc ()
    (interactive)
    (sql-start-session "~/.sql-scripts/mysql-poc" "mysql"))

(defun sql-start-mysql (arg)
    (interactive)
    (message "My arg is %s" arg)
    (sql-start-session arg "mysql"))


(defun sql-start-local-mysql ()
    (interactive)
    (sql-start-session "~/.sql-scripts/mysql-local" "mysql"))

(defun sql-start-sqlite3 ()
    (interactive)
    (sql-start-session "/usr/bin/sqlite3" "sqlite"))


(defun make-number (n)
      "Turn a string into a number, being tolerant of commas and even other 
       'junk'."
    (while (string-match "[^-0-9.]" n)
      (setq n (replace-match "" nil nil n)))
      (string-to-number n))





(defun wrap-text (before after)
  (setq word-at-point (buffer-substring-no-properties (region-beginning) (region-end)))
  (setq wrapped-word (concat before word-at-point after))
  (delete-region (region-beginning) (region-end))
  (insert wrapped-word))

(defun teradata-format-as-date ()
  "Format the selected item as YYYY-MM-DD"
  (interactive)
  (wrap-text "cast((" " (format 'YYYY-MM-DD')) as char(10))"))

(defun teradata-format-as-currency ()
  "Format the selected item as -$1,200.99"
  (interactive)
  (wrap-text "" "(format '--$$ZZZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZ9.99') "))

(defun teradata-format-as-number ()
  "Format the selected item as -1,200"
  (interactive)
  (wrap-text "" " (format '--ZZZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZZ') "))


(defun teradata-format-as-percent ()
"Format the selected item as 10.1%"
(interactive)
  (wrap-text "" " (format '--ZZZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZ9.9%') "))

(defun send-latest-results-to-excel ()
  (interactive)
  (cond ((string= sql-product "db2")
         (teradata-send-latest-results-to-excel))
	((string= sql-product "sqlite")
         (message "Send latest results to Excel is not supported on sqlite"))
	((string= sql-product "mysql")
         (mysql-send-latest-results-to-excel))))

(defun teradata-send-latest-results-to-excel ()
 (interactive)
 (set-buffer "*SQL*")
 (goto-char (point-max))
 (forward-line -2)
 (let ((beg (point)))
  (search-backward " *** Total elapsed time was" nil)
  (forward-line 2)
  (let ((end (point)))
    (send-to-excel beg end)
)))


(defun mysql-send-latest-results-to-excel ()
 (interactive)
 (set-buffer "*SQL*")
 (goto-char (point-max))
 (forward-line -4)
 (end-of-line)
 (let ((beg (point))
       (buf (current-buffer)))
   (search-backward-regexp "^+-" nil t 2)
   (forward-line)
   (let ((end (point)))
     (with-temp-buffer
       (rename-buffer "*sql temp*" t)
       (insert-buffer-substring buf beg end)
       (goto-char (point-min))
       (forward-line)
       (kill-line)
       (kill-line)
       (send-to-excel (point-min) (point-max))))))



(defun teradata-send-latest-results-to-data-mode ()
 (interactive)
 (set-buffer "*SQL*")
 (goto-char (point-max))
 (forward-line -2)
 (let ((beg (point)))
  (search-backward " *** Total elapsed time was" nil)
  (forward-line 2)
  (let ((end (point)))
    (send-to-new-buffer beg end)
    )))

(defun teradata-send-latest-results-to-org-mode ()
 (interactive)
 (set-buffer "*SQL*")
 (goto-char (point-max))
 (forward-line -2)
 (let ((beg (point)))
  (search-backward " *** Total elapsed time was" nil)
  (forward-line 2)
  (let ((end (point)))
    (send-to-new-org-buffer beg end)
    )))

(defun send-to-new-buffer (beg end)
  (interactive "r")
  (let ((mybuf (current-buffer)))
    (message "Buf %s beg %s %s %s " mybuf beg end (current-buffer))
    (setq newbuf (generate-new-buffer "Data Buffer"))
    (switch-to-buffer newbuf nil t)
    (insert-buffer-substring mybuf beg end)
    (data-mode)
    ))
 

(defun send-to-new-org-buffer (beg end)
  (interactive "r")
  (let ((mybuf (current-buffer)))
    (message "Buf %s beg %s %s %s " mybuf beg end (current-buffer))
    (setq newbuf (generate-new-buffer "results.org"))
    (switch-to-buffer newbuf nil t)
    (insert-buffer-substring mybuf beg end)
    (beginning-of-buffer)
    (while (search-forward "|" nil t)
      (replace-match "	" nil nil)))
    (org-mode)
    (org-table-convert-region (buffer-end -1) (buffer-end 1) '(16))
    (beginning-of-buffer)
    (org-table-insert-hline))

(defun send-current-statement ()
  (interactive)
  (mark-current-statement 1)
  (sql-send-region (mark) (point)))

(defun send-current-paragraph ()
  (interactive)
  (mark-paragraph)
  (sql-send-region (mark) (point)))


(defun send-region-to-excel ()
 (interactive)
    (send-to-excel (point) (mark)))

(defun send-to-excel (beg end)
" the results from *SQL* and import to Excel"
 (interactive)
 (let ((x (make-temp-file "foo")))
   (message x)
   (write-region beg end x)
   (let ((command (concat "osascript -e \"set falias to (POSIX file \\\"" x "\\\")\"" 
                        " -e \"tell application \\\"Microsoft Excel\\\"\""
                        " -e \"activate\""
                        " -e \"open text file filename falias origin Macintosh start row 1 data type delimited field info {{1, text format} } other char \\\"|\\\" with use other\""
                        " -e \"end tell\""
                        )))
 (start-process-shell-command "foo-command"  "foo" command))))

;; TODO add sql-mode-hook to hook the .sql buffer up to a running *SQL* buffer, if active
(require 'sql)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)



;; SQL Mode Keybindings

(define-key sql-mode-map "\C-c\C-d" 'teradata-format-as-date)
(define-key sql-mode-map "\C-c\C-m" 'teradata-format-as-currency)
(define-key sql-mode-map "\C-c\C-n" 'teradata-format-as-number)
(define-key sql-mode-map "\C-c\C-e" 'teradata-send-latest-results-to-excel)
(define-key sql-mode-map "\C-c\C-g" 'send-region-to-excel)
(define-key sql-mode-map "\C-c\C-o" 'teradata-send-latest-results-to-org-mode)
(define-key sql-mode-map "\C-\M-h" 'mark-current-statement)
(define-key sql-mode-map "\C-c\C-c" 'send-current-statement)
(define-key sql-mode-map "\C-c\C-p" 'send-current-paragraph)



(provide 'sql-tools)

;;; nav.el ends here

