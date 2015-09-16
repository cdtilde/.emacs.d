
;; Required to syntax-color code when exporting to Latex
;; Requires Pygmentize. To install: sudo easy_install Pygments
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))


(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (sh . t)
   (calc . t)
   (sql . t)
   (R . t)
   (emacs-lisp . t)))

(setq org-confirm-babel-evaluate nil)

;;(require 'ess-site)



(defun cf (calcarg formatarg &optional thousands &optional dollar)
  "Calcualtes the formulat calcarg and formats the result using using the printf formatarg format. In addition to formatarg, cf will optionally add a thousand separator (,) and a dollar sign."
  (interactive)
  (message "Calcarg = %s, formatarg = %s, thousands=%s, dollar=%s" calcarg formatarg thousands dollar)
  (let ((c (string-to-number (calc-eval calcarg))))
    (message "C = %d" c)
    (concat (if dollar "$")
            (if thousands
                (calc-eval '("$" calc-group-digits t) 'num (truncate c))
              (number-to-string (truncate c)))
            (substring (format formatarg (- c (truncate c))) 1 nil))))

(defun currency-format(formatarg arg)
  (concat "$"
          (calc-eval '("$" calc-group-digits t) 'num (truncate arg))
          (substring (format formatarg (- arg (truncate arg))) 1 nil)))

(defun de-currency(arg)
  (setq arg (replace-regexp-in-string "\\$" "" arg))
  (setq arg (replace-regexp-in-string "," "" arg)))    

(add-hook 'org-mode-hook (lambda ()
                           (progn

                           ;; Modified version to allow $ signs and thousands separators in column values
                           (defun org-table-eval-formula (&optional arg equation
                                                                    suppress-align suppress-const
                                                                    suppress-store suppress-analysis)
                             "Replace the table field value at the cursor by the result of a calculation.

This function makes use of Dave Gillespie's Calc package, in my view the
most exciting program ever written for GNU Emacs.  So you need to have Calc
installed in order to use this function.

In a table, this command replaces the value in the current field with the
result of a formula.  It also installs the formula as the \"current\" column
formula, by storing it in a special line below the table.  When called
with a `C-u' prefix, the current field must be a named field, and the
formula is installed as valid in only this specific field.

When called with two `C-u' prefixes, insert the active equation
for the field back into the current field, so that it can be
edited there.  This is useful in order to use \\[org-table-show-reference]
to check the referenced fields.

When called, the command first prompts for a formula, which is read in
the minibuffer.  Previously entered formulas are available through the
history list, and the last used formula is offered as a default.
These stored formulas are adapted correctly when moving, inserting, or
deleting columns with the corresponding commands.

The formula can be any algebraic expression understood by the Calc package.
For details, see the Org-mode manual.

This function can also be called from Lisp programs and offers
additional arguments: EQUATION can be the formula to apply.  If this
argument is given, the user will not be prompted.  SUPPRESS-ALIGN is
used to speed-up recursive calls by by-passing unnecessary aligns.
SUPPRESS-CONST suppresses the interpretation of constants in the
formula, assuming that this has been done already outside the function.
SUPPRESS-STORE means the formula should not be stored, either because
it is already stored, or because it is a modified equation that should
not overwrite the stored one."
                             (interactive "P")
                             (org-table-check-inside-data-field)
                             (or suppress-analysis (org-table-get-specials))
                             (if (equal arg '(16))
                                 (let ((eq (org-table-current-field-formula)))
                                   (or eq (user-error "No equation active for current field"))
                                   (org-table-get-field nil eq)
                                   (org-table-align)
                                   (setq org-table-may-need-update t))
                               (let* (fields
                                      (ndown (if (integerp arg) arg 1))
                                      (org-table-automatic-realign nil)
                                      (case-fold-search nil)
                                      (down (> ndown 1))
                                      (formula (if (and equation suppress-store)
                                                   equation
                                                 (org-table-get-formula equation (equal arg '(4)))))
                                      (n0 (org-table-current-column))
                                      (org-tbl-calc-modes (copy-sequence org-calc-default-modes))
                                      (numbers nil) ; was a variable, now fixed default
                                      (keep-empty nil)
                                      n form form0 formrpl formrg bw fmt x ev orig c lispp literal
                                      duration duration-output-format currency)
                                 ;; Changed previous line - initialized currency
                                 ;; Parse the format string.  Since we have a lot of modes, this is
                                 ;; a lot of work.  However, I think calc still uses most of the time.
                                 (if (string-match ";" formula)
                                     (let ((tmp (org-split-string formula ";")))
                                       (setq formula (car tmp)
                                             fmt (concat (cdr (assoc "%" org-table-local-parameters))
                                                         (nth 1 tmp)))
                                       (while (string-match "\\([pnfse]\\)\\(-?[0-9]+\\)" fmt)
                                         (setq c (string-to-char (match-string 1 fmt))
                                               n (string-to-number (match-string 2 fmt)))
                                         (if (= c ?p)
                                             (setq org-tbl-calc-modes (org-set-calc-mode 'calc-internal-prec n))
                                           (setq org-tbl-calc-modes
                                                 (org-set-calc-mode
                                                  'calc-float-format
                                                  (list (cdr (assoc c '((?n . float) (?f . fix)
                                                                        (?s . sci) (?e . eng))))
                                                        n))))
                                         (setq fmt (replace-match "" t t fmt)))
                                       (if (string-match "T" fmt)
                                           (setq duration t numbers t
                                                 duration-output-format nil
                                                 fmt (replace-match "" t t fmt)))
                                       (if (string-match "t" fmt)
                                           (setq duration t
                                                 duration-output-format org-table-duration-custom-format
                                                 numbers t
                                                 fmt (replace-match "" t t fmt)))
                                       (if (string-match "N" fmt)
                                           (setq numbers t
                                                 fmt (replace-match "" t t fmt)))
                                       (if (string-match "L" fmt)
                                           (setq literal t
                                                 fmt (replace-match "" t t fmt)))
                                       ;; Start Change -- format specified of "Currency"
                                       (if (string-match "C" fmt)
                                           (setq currency t
                                                 fmt (replace-match "" t t fmt)))
                                       ;; End Change
                                       (if (string-match "E" fmt)
                                           (setq keep-empty t
                                                 fmt (replace-match "" t t fmt)))
                                       (while (string-match "[DRFS]" fmt)
                                         (setq org-tbl-calc-modes (org-set-calc-mode (match-string 0 fmt)))
                                         (setq fmt (replace-match "" t t fmt)))
                                       (unless (string-match "\\S-" fmt)
                                         (setq fmt nil))))
                                 (if (and (not suppress-const) org-table-formula-use-constants)
                                     (setq formula (org-table-formula-substitute-names formula)))
                                 (setq orig (or (get-text-property 1 :orig-formula formula) "?"))
                                 (while (> ndown 0)
                                   (setq fields (org-split-string
                                                 (buffer-substring-no-properties (point-at-bol) (point-at-eol))
                                                 " *| *"))
                                   ;; replace fields with duration values if relevant
                                   (if duration
                                       (setq fields
                                             (mapcar (lambda (x) (org-table-time-string-to-seconds x))
                                                     fields)))
                                   (if (eq numbers t)
                                       (setq fields (mapcar
                                                     (lambda (x)
                                                       (if (string-match "\\S-" x)
                                                           (number-to-string (string-to-number x))
                                                         x))
                                                     fields)))
                                   (setq ndown (1- ndown))
                                   (setq form (copy-sequence formula)
                                         lispp (and (> (length form) 2) (equal (substring form 0 2) "'(")))
                                   (if (and lispp literal) (setq lispp 'literal))

                                   ;; Insert row and column number of formula result field
                                   (while (string-match "[@$]#" form)
                                     (setq form
                                           (replace-match
                                            (format "%d"
                                                    (save-match-data
                                                      (if (equal (substring form (match-beginning 0)
                                                                            (1+ (match-beginning 0)))
                                                                 "@")
                                                          (org-table-current-dline)
                                                        (org-table-current-column))))
                                            t t form)))

                                   ;; Check for old vertical references
                                   (setq form (org-table-rewrite-old-row-references form))
                                   ;; Insert remote references
                                   (while (string-match "\\<remote([ \t]*\\([-_a-zA-Z0-9]+\\)[ \t]*,[ \t]*\\([^\n)]+\\))" form)
                                     (setq form
                                           (replace-match
                                            (save-match-data
                                              (org-table-make-reference
                                               (let ((rmtrng (org-table-get-remote-range
                                                              (match-string 1 form) (match-string 2 form))))
                                                 (if duration
                                                     (if (listp rmtrng)
                                                         (mapcar (lambda(x) (org-table-time-string-to-seconds x)) rmtrng)
                                                       (org-table-time-string-to-seconds rmtrng))
                                                   rmtrng))
                                               keep-empty numbers lispp))
                                            t t form)))
                                   ;; Insert complex ranges
                                   (while (and (string-match org-table-range-regexp form)
                                               (> (length (match-string 0 form)) 1))
                                     (message "Match is %s" (match-string 0 form))
                                     (setq formrg (save-match-data
                                                    (org-table-get-range (match-string 0 form) nil n0)))
                                     (message "formrg is %s" formrg)
                                     (setq formrpl
                                           (save-match-data
                                             (org-table-make-reference
                                              ;; possibly handle durations
                                              (if duration
                                                  (if (listp formrg)
                                                      (mapcar (lambda(x) (org-table-time-string-to-seconds x)) formrg)
                                                    (org-table-time-string-to-seconds formrg))
                                                ;; Begin Change - handle vectors from range specifications 
                                                (if (and (listp formrg) currency)
                                                    (mapcar (lambda(x) (de-currency x)) formrg)
                                                  formrg))
                                              ;; End Change
                                              keep-empty numbers lispp)))
                                     (message "After, formrepl = %s" formrpl)
                                     (if (not (save-match-data
                                                (string-match (regexp-quote form) formrpl)))
                                         (setq form (replace-match formrpl t t form))
                                       (user-error "Spreadsheet error: invalid reference \"%s\"" form)))
                                   ;; Insert simple ranges
                                   (while (string-match "\\$\\([0-9]+\\)\\.\\.\\$\\([0-9]+\\)"  form)
                                     (setq form
                                           (replace-match
                                            (save-match-data
                                              (org-table-make-reference
                                               (org-sublist
                                                fields (string-to-number (match-string 1 form))
                                                (string-to-number (match-string 2 form)))
                                               keep-empty numbers lispp))
                                            t t form)))
                                   (setq form0 form)
                                   ;; Insert the references to fields in same row
                                   (while (string-match "\\$\\(\\([-+]\\)?[0-9]+\\)" form)
                                     (message (match-string 1 form))
                                     (setq n (+ (string-to-number (match-string 1 form))
                                                (if (match-end 2) n0 0))
                                           x (nth (1- (if (= n 0) n0 (max n 1))) fields))
                                     ;; Begin change - eliminate $ and , from the input value
                                     (when (and currency x)
                                       (message "Second thing")
                                       (setq x (de-currency x)))
                                     ;; End Change
                                     (unless x (user-error "Invalid field specifier \"%s\""
                                                           (match-string 0 form)))
                                     (setq form (replace-match
                                                 (save-match-data
                                                   (org-table-make-reference
                                                    x keep-empty numbers lispp))
                                                 t t form)))

                                   (if lispp
                                       (setq ev (condition-case nil
                                                    (eval (eval (read form)))
                                                  (error "#ERROR"))
                                             ev (if (numberp ev) (number-to-string ev) ev)
                                             ev (if duration (org-table-time-seconds-to-string
                                                              (string-to-number ev)
                                                              duration-output-format) ev))
                                     (or (fboundp 'calc-eval)
                                         (user-error "Calc does not seem to be installed, and is needed to evaluate the formula"))
                                     ;; Use <...> time-stamps so that Calc can handle them
                                     (setq form (replace-regexp-in-string org-ts-regexp3 "<\\1>" form))
                                     ;; I18n-ize local time-stamps by setting (system-time-locale "C")
                                     (when (string-match org-ts-regexp2 form)
                                       (let* ((ts (match-string 0 form))
                                              (tsp (apply 'encode-time (save-match-data (org-parse-time-string ts))))
                                              (system-time-locale "C")
                                              (tf (or (and (save-match-data (string-match "[0-9]\\{1,2\\}:[0-9]\\{2\\}" ts))
                                                           (cdr org-time-stamp-formats))
                                                      (car org-time-stamp-formats))))
                                         (setq form (replace-match (format-time-string tf tsp) t t form))))

                                     (setq ev (if (and duration (string-match "^[0-9]+:[0-9]+\\(?::[0-9]+\\)?$" form))
                                                  form
                                                (calc-eval (cons form org-tbl-calc-modes)
                                                           (when (and (not keep-empty) numbers) 'num)))
                                           ev (if duration (org-table-time-seconds-to-string
                                                            (if (string-match "^[0-9]+:[0-9]+\\(?::[0-9]+\\)?$" ev)
                                                                (string-to-number (org-table-time-string-to-seconds ev))
                                                              (string-to-number ev))
                                                            duration-output-format)
                                                ev)))

                                   (when org-table-formula-debug
                                     (with-output-to-temp-buffer "*Substitution History*"
                                       (princ (format "Substitution history of formula
Orig:   %s
$xyz->  %s
@r$c->  %s
$1->    %s\n" orig formula form0 form))
                                       (if (listp ev)
                                           (princ (format "        %s^\nError:  %s"
                                                          (make-string (car ev) ?\-) (nth 1 ev)))
                                         (princ (format "Result: %s\nFormat: %s\nFinal:  %s"
                                                        ev (or fmt "NONE")
                                                        (if fmt (currency-format fmt (string-to-number ev)) ev)))))
                                     (setq bw (get-buffer-window "*Substitution History*"))
                                     (org-fit-window-to-buffer bw)
                                     (unless (and (org-called-interactively-p 'any) (not ndown))
                                       (unless (let (inhibit-redisplay)
                                                 (y-or-n-p "Debugging Formula.  Continue to next? "))
                                         (org-table-align)
                                         (user-error "Abort"))
                                       (delete-window bw)
                                       (message "")))
                                   (if (listp ev) (setq fmt nil ev "#ERROR"))
                                   (org-table-justify-field-maybe
                                    (format org-table-formula-field-format
                                            (if fmt (currency-format fmt (string-to-number ev)) ev)))
                                   (if (and down (> ndown 0) (looking-at ".*\n[ \t]*|[^-]"))
                                       (call-interactively 'org-return)
                                     (setq ndown 0)))
                                 (and down (org-table-maybe-recalculate-line))
                                 (or suppress-align (and org-table-may-need-update
                                                         (org-table-align))))))
                           )


                           
; NOTE: cl is required for org-babel-execute (case statement)
(require 'cl)
(defun org-babel-execute:sql (body params)
  "Execute a block of Sql code with Babel.
This function is called by `org-babel-execute-src-block'."
  (let* ((result-params (cdr (assoc :result-params params)))
         (cmdline (cdr (assoc :cmdline params)))
         (dbhost (cdr (assoc :dbhost params)))
         (dbuser (cdr (assoc :dbuser params)))
         (dbpassword (cdr (assoc :dbpassword params)))
         (database (cdr (assoc :database params)))
         (engine (cdr (assoc :engine params)))
         (colnames-p (not (equal "no" (cdr (assoc :colnames params)))))
         (in-file (org-babel-temp-file "sql-in-"))
         (out-file (or (cdr (assoc :out-file params))
                       (org-babel-temp-file "sql-out-")))
	 (header-delim "")
         (command (case (intern engine)
                    ('dbi (format "dbish --batch %s < %s | sed '%s' > %s"
				  (or cmdline "")
				  (org-babel-process-file-name in-file)
				  "/^+/d;s/^\|//;s/(NULL)/ /g;$d"
				  (org-babel-process-file-name out-file)))
                    ('monetdb (format "mclient -f tab %s < %s > %s"
                                      (or cmdline "")
                                      (org-babel-process-file-name in-file)
                                      (org-babel-process-file-name out-file)))
                    ('msosql (format "osql %s -s \"\t\" -i %s -o %s"
                                     (or cmdline "")

                                     (org-babel-process-file-name in-file)
                                     (org-babel-process-file-name out-file)))
                    ('teradata (format "~/.emacs.d/bteq_org.sh %s %s < %s > %s"
				    (if colnames-p "" "-N")
                                    (or cmdline "")
				    (org-babel-process-file-name in-file)
				    (org-babel-process-file-name out-file)))

                    ('mysql (format "mysql %s %s %s < %s > %s"
				    (dbstring-mysql dbhost dbuser dbpassword database)
				    (if colnames-p "" "-N")
                                    (or cmdline "")
				    (org-babel-process-file-name in-file)
				    (org-babel-process-file-name out-file)))
		    ('postgresql (format
				  "psql -A -P footer=off -F \"\t\"  -f %s -o %s %s"
				  (org-babel-process-file-name in-

                                                               file)
				  (org-babel-process-file-name out-file)
				  (or cmdline "")))
                    (t (error "No support for the %s SQL engine" engine)))))
    (with-temp-file in-file
      (insert
       (case (intern engine)
	 ('dbi "/format partbox\n")
	 (t ""))
       (org-babel-expand-body:sql body params)
       (case (intern engine)
         ('teradata "\n")
         (t ""))))
    (message command)
    (org-babel-eval command "")
    (org-babel-result-cond result-params
      (with-temp-buffer
	  (progn (insert-file-contents-literally out-file) (buffer-string)))
      (with-temp-buffer
	(cond
	  ((or (eq (intern engine) 'mysql)
               (eq (intern engine) 'teradata)
	       (eq (intern engine) 'dbi)
	       (eq (intern engine) 'postgresql))
	   ;; Add header row delimiter after column-names header in first line
	   (cond
	    (colnames-p
	     (with-temp-buffer
	       (insert-file-contents out-file)
	       (goto-char (point-min))
	       (forward-line 1)
	       (insert "-\n")
	       (setq header-delim "-")
	       (write-file out-file)))))
	  (t
	   ;; Need to figure out the delimiter for the header row
	   (with-temp-buffer
	     (insert-file-contents out-file)
	     (goto-char (point-min))
	     (when (re-search-forward "^\\(-+\\)[^-]" nil t)
	       (setq header-delim (match-string-no-properties 1)))
	     (goto-char (point-max))
	     (forward-char -1)
	     (while (looking-at "\n")
	       (delete-char 1)
	       (goto-char (point-max))
	       (forward-char -1))
	     (write-file out-file))))
	(org-table-import out-file '(16))
	(org-babel-reassemble-table


	 (mapcar (lambda (x)
		   (if (string= (car x) header-delim)
		       'hline
		     x))
		 (org-table-to-lisp))
	 (org-babel-pick-name (cdr (assoc :colname-names params))
			      (cdr (assoc :colnames params)))
	 (org-babel-pick-name (cdr (assoc :rowname-names params))
			      (cdr (assoc :rownames params))))))))

          ))



(provide 'init-org-mode)
