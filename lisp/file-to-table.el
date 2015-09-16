(defvar f-to-t/teradata-script  "~/Documents/Sears/Code/file-to-table/file-to-teradata"
  "The python script used to perform the upload to Teradata")

(defvar f-to-t/sqlite-script  "~/Documents/Sears/Code/file-to-table/file-to-sqlite"
  "The python script used to perform the upload to Teradata")


(defun f-to-t/replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))

(defun f-to-t/send-file-to-teradata ()
  " Send the file to a Teradata table using fastload. Will execute the Python script python-script.\n

File must have the following properties:
* Header row with valid Teradata column names
* Pipe-delimited values
* All values must fit in 250 characters
* First column is the primary key and must be unique (duplicates will be discarded). Use (make-lines-unique) to insert an artificial key on the file"
  (interactive)
  (let* ((quoted-name (f-to-t/replace-in-string " " "\\ " (buffer-file-name)))         
        (command (concat  f-to-t/teradata-script  " " quoted-name " ezachri & ")))
    (message "Executing command %s" command)
    (shell-command command)))



(defun f-to-t/send-file-to-sqlite ()
  " Send the file to a Teradata table using fastload. Will execute the Python script python-script.\n

File must have the following properties:
* Header row with valid Teradata column names
* Pipe-delimited values
* All values must fit in 250 characters
* First column is the primary key and must be unique (duplicates will be discarded). Use (make-lines-unique) to insert an artificial key on the file"
  (interactive)
  (let* ((quoted-name (f-to-t/replace-in-string " " "\\ " (buffer-file-name)))         
        (command (concat  f-to-t/sqlite-script  " " quoted-name "  & ")))
    (message "Executing command %s" command)
    (shell-command command)))




(defun f-to-t/make-lines-unique ()
  (interactive)
  (goto-char (point-min))
  (insert " primkey | " )
  (forward-line 1)
  (let ((i '1))
    (while (< (point) (point-max))
      (beginning-of-line)
      (insert (concat (number-to-string i) " | "))
      (forward-line 1)
      (setq i (+ i 1)))))

;; file-to-table keybindings
(global-set-key (kbd "C-c f t") 'f-to-t/send-file-to-teradata)
(global-set-key (kbd "C-c f s") 'f-to-t/send-file-to-sqlite)


(provide 'file-to-table)
