(replace-regexp "read\\(file\\)?" "get")

(defun remove-outline-marks ()
  "Remove section header marks created in outline-mode"
  (interactive)
  (replace-regexp "^\\*+" ""))



"[.?!][]\"')}]*\\($\\|\t\\|  \\)[ \t\n]*" ;sentence end


"\\<program\\('s\\|s\\)?\\>"            ;program, program's, programs



(replace-regexp "\\<program\\('s\\|s\\)?\\>" "module\\1")


