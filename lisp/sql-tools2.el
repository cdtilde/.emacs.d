

(setq sql-connection-alist
      '((mysql-poc (sql-product 'mysql)
                  (sql-port 3372)
                  (sql-server "157.241.144.80")
                  (sql-user "ezachri")
                  (sql-password "dummy")
                  (sql-database "sywr"))
        (server2 (sql-product 'postgres)
                  (sql-port 5432)
                  (sql-server "localhost")
                  (sql-user "user")
                  (sql-database "db2"))))



(defadvice sql-connect (before decrypt-passwords (args) activate)
  "Read connection passwords from ~/.emacs-secrets.el.gpg. Passwords must be stored with the same name as the connection name."
  (require 'init-secrets)
  (mapc (lambda (arg) ;(delete sql-password arg)
          (delete 'sql-password (cdr arg)) sql-connection-alist)
          )  sql-connection-alist)
  (let ((connection-info (assoc connection sql-connection-alist))
  (message (car sql-passwords))
  
  (sql-password (car (last (assoc connection my-sql-password)))))
 

    ;(add-to-list arg (cdr (assoc (car arg) sql-passwords)))



    ;; (let ((a '(1 2 3)) (b '(3 4 5))
    ;;       (total 0))
    ;;   (mapc (lambda (arg) (setq total (+ total arg))) a)
    ;;   (message "Total: %d" total))
    
