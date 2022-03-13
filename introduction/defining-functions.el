(defun count-words-buffer ()
  (let ((count 0))
    (save-excursion
      (goto-char (point-min))
      (while (< (point) (point-max))
        (forward-word 1)
        (setq count (1+ count)))
      (message "buffer contains %d words." count))))
;; count-words-buffer

(message "\"%s\" is a string, %d is a number, and %c is a character"
         "hi there" 142 ?q)
;; "\"hi there\" is a string, 142 is a number, and q is a character"

(message "This book was printed in %f, also known as %e." 2004 2004)
;; "This book was printed in 2004.000000, also known as 2.004000e+03."


(defun count-words-buffer ()
  "Count the number of words in the current buffer;
     print a message in the minibuffer with the result."
  (interactive)
  (save-excursion
    (let ((count 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
        (forward-word 1)
        (setq count (1+ count)))
      (message "buffer contains %d words." count))))
;; count-words-buffer

(defun goto-percent (pct)
  (interactive "nPercent: ")
  (goto-char (/ (* pct (point-max)) 100)))
;; goto-percent



