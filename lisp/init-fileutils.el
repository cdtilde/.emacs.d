(defun copy-current-path-to-system-clipboard ()
  (interactive)
  (let ((dirname (file-name-directory (buffer-file-name))))
        (with-temp-buffer
          (insert dirname)
          (mark-whole-buffer)
          (pasteboard-copy))))

(defun file-info ()
  (interactive)
  (if (not (buffer-file-name))
      (message "Buffer does not have a file: line %d of %d"
               (line-number-at-pos)
               (count-lines (point-min) (point-max)))
    (progn 
      (let ((file-attributes (file-attributes (buffer-file-name) 'string)))
        (let ((size (nth 7 file-attributes)))
          (message "\"%s\": line %d of %d (%d bytes) %s"
                   (buffer-file-name)
                   (line-number-at-pos)
                   (count-lines (point-min) (point-max))
                   size
                   (if (file-writable-p (buffer-file-name)) "Read/Write" "Read Only")))))))



(provide 'init-fileutils)
