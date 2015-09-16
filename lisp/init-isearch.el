
;; isearch
;; When completing searching by pressing enter, move point
;; to the beginning of the match (instead of at the end of the match
;; which is the default behavior)
;; If searching for 1 character only, move the point forward by 1 character
;; after matching (assuming that the user is trying to match a delimiter, such as ", ', }, ( etc.

(defun isearch-move-point-to-match-beginning ()
  (if isearch-forward (backward-char (length isearch-string)))
  (message "%d" (length isearch-string))
  (if (= (length isearch-string) 1) (forward-char 1)))

(add-hook 'isearch-mode-end-hook 'isearch-move-point-to-match-beginning)

;; Show number of matches while searching
(when (maybe-require-package 'anzu)
  (global-anzu-mode t)
  (diminish 'anzu-mode)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key [remap query-replace] 'anzu-query-replace))

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)


(provide 'init-isearch)
