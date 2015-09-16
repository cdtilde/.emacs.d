;; OS X options
(setq mac-option-modifier 'meta)

(setq ns-use-native-fullscreen t)  ;; Put Emacs in a separate space

(if (display-graphic-p)
    (progn
      (fringe-mode '(10 . 0))
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      (menu-bar-mode 1))
  (progn
    (tool-bar-mode)
    (scroll-bar-mode 0)
    (fringe-mode 0)
    (menu-bar-mode 0)))




(defun pasteboard-copy()
  "Copy region to OS X system pasteboard."
  (interactive)
  (shell-command-on-region
   (region-beginning) (region-end) "pbcopy"))

(defun pasteboard-paste()
  "Paste from OS X system pasteboard via `pbpaste' to point."
  (interactive)
  (shell-command-on-region
   (point) (if mark-active (mark) (point)) "pbpaste" nil t))

(defun pasteboard-cut()
  "Cut region and put on OS X system pasteboard."
  (interactive)
  (pasteboard-copy)
    (delete-region (region-beginning) (region-end)))


(provide 'init-osx)
