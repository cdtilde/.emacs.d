(setq gnus-select-method '(nnimap "gmail"
(nnimap-address "imap.gmail.com")
(nnimap-server-port 993)
(nnimap-stream ssl)
(send-mail-function (quote smtpmail-send-it))
(smtpmail-smtp-server "smtp.googlemail.com")
(smtpmail-smtp-service 587))


;; 1) Open Emacs and hit C-x m to bring up the unsent mail buffer
;; 2) Write a test email and hit C-c C-c to send
;; 3) At the prompts, choose SMTP and then enter smtp.googlemail.com for server. 
;; 4) Enter username and password 
;; 5) Say yes to save password to ~/.authinfo authentication file.
;; 6) And that's it.  It really is that easy.
;; NOTE: the password should be the device-specific password provided by google



(provide 'init-gmail)
