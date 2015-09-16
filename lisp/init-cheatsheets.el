(defun cheatsheet-open ()
  (interactive)
  (find-file-other-window (concat "~/.dotfiles/emacs-cheatsheets/" (format "%s" major-mode) ".org")))

(provide 'init-cheatsheets)
