
(global-set-key (kbd "<wheel-right>")  (lambda ()(interactive) (scroll-left 2)))
(global-set-key (kbd "<wheel-left>")  (lambda ()(interactive) (scroll-right 2)))

(put 'scroll-left 'disabled nil)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)


(provide 'init-mouse)
