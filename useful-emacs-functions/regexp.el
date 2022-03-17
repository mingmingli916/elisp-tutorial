(replace-regexp "read\\(file\\)?" "get")

(defun remove-outline-marks ()
  "Remove section header marks created in outline-mode"
  (interactive)
  (replace-regexp "^\\*+" ""))



"[.?!][]\"')}]*\\($\\|\t\\|  \\)[ \t\n]*" ;sentence end


"\\<program\\('s\\|s\\)?\\>"            ;program, program's, programs



(replace-regexp "\\<program\\('s\\|s\\)?\\>" "module\\1")


;; returns a string containing the portion of the buffer that matches the nth parenthesized subexpression
(buffer-substring (match-beginning n (match-end n)))



