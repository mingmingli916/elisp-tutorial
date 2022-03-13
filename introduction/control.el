(defun pluralize (word count)
  (if (= count 1)
      word
    (concat word "s")))
;; pluralize

(pluralize "goat" 5)                    ;"goats"
(pluralize "change" 1)                  ;"change"


(defun pluralize (word count &optional plural)
  (if (= count 1)
      word
    (if (null plural)
        (concat word "s")
      plural)))
;; pluralize
(pluralize "mouse" 5 "mice")            ;"mice"
(pluralize "mouse" 1 "mice")            ;"mouse"



(defun how-many (count)
  (cond ((zerop count) "no")            ; zero predicate
        ((= count 1) "one")
        ((= count 2) "two")
        (t "many")))
;; how-many

(how-many 1)                            ;"one"
(how-many 0)                            ;"no"
(how-many 3)                            ;"many"

(defun report-change-count (count)
  (message "Made %s %s." (how-many count) (pluralize "change" count)))
;; report-change-count

(report-change-count 0)                 ;"Made no changes."
(report-change-count 1)                 ;"Made one change."
(report-change-count 10)                ;"Made many changes."
