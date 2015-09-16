(defun e/time-subtract-millis (b a)
 (round  (* 1000 (float-time (time-subtract b a)))))


(defvar e/require-times nil
  "A list of (FEATURE . LOAD-DURATION).
LOAD-DURATION is the time taken in milliseconds to load FEATURE.")


(defadvice require
  (around build-require-times (feature &optional filename noerror) activate)
  "Note in `e/require-times' the time taken to require each feature."
  (let* ((already-loaded (memq feature features))
         (require-start-time (and (not already-loaded) (current-time))))
    (prog1
        ad-do-it
      (when (and (not already-loaded) (memq feature features))
        (add-to-list 'e/require-times
                     (cons feature
                           (e/time-subtract-millis (current-time)
                                                           require-start-time))
                     t)))))

(defun e/sorttimes(a b)
  (> (cdr a) (cdr b)))

(defun e/benchmarks-show()
  (interactive)
  (setq e/require-times (sort e/require-times 'e/sorttimes))
  (pp-eval-expression 'e/require-times))



(provide 'init-benchmarking)
