

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(defun cousine-font()  
  (interactive)
  (progn
    (set-default-font "-*-Cousine-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
    (add-to-list 'default-frame-alist '
                 (font . "-*-Cousine-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1"))
    ))


(defun iawriter()
  (interactive)
  (load-theme 'iawriter t))

(defun wombat()
  (interactive)
  (load-theme 'wombat2 t)
  (cousine-font))


(wombat)

; Turn line numbers on or off in this buffer only
; If it's turned on, add a one-character fringe
(defun toggle-line-numbers()
  (interactive)
  (if (and (boundp 'linum-mode) linum-mode)
      (linum-mode 0)
    (progn
      (linum-mode 1)
      (setq linum-format " %d ")))) 

(provide 'init-look)
