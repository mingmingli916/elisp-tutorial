;; template.el
;; Routines for generating smart skeletal tempaltes for files.

(defvar template-file-name "file-template"
  "*The name of the file to look for when a find-file request fails. If a
file with the name specified by this variable exists, offer to use it as
a template for creating the new file. You can also have mode-specific
templates by appending \"-extension\" to this filename, e.g. a Java specific
template would be file-template-java.")

(defvar template-replacements-alist
  '(("%filename%" . (lambda ()
                      (file-name-nondirectory (buffer-file-name))))
    ("%creator%" . user-full-name)
    ("%author%" . user-full-name)
    ("%date%" . current-time-string)
    ("%once%" . (lambda () (template-insert-include-once)))
    ("%package%" . (lambda () (template-insert-java-package)))
    ("%class%" . (lambda () (template-insert-class-name)))
    )
  "A list which specifies what substitutions to perform upon loading a
template file. Each list element consists of a string, which is the target
to be replaced if it is found in the template, paired with a function,
which is called to generate the replacement value for the string.")

(defun find-template-file ()
  "Searches the current directory and its parents for a file matching
the name configured for template files. The name of the first such
readable file found is returned, allowing for hierarchical template
configuration. A template file with the same extension as the file
being loaded (using a \"-\" instead of a \".\" as the template file's
delimiter, to avoid confusing other software) will take precedence
over an extension-free, generic template."
  (let ((path (file-name-directory (buffer-file-name)))
        (ext (file-name-extension (buffer-file-name)))
        attempt result)
    (while (and (not result) (> (length path) 0))
      ;; compose the template file (with extension)
      ;; fullpath with current buffer path
      (setq attempt (concat path template-file-name "-" ext)) 
      (if (file-readable-p attempt)     
          (setq result attempt)
        (setq attempt (concat path template-file-name)) ;without ext
        (if (file-readable-p attempt)
            (setq result attempt)
          (setq path (if (string-equal path "/")
                         ""
                       (file-name-directory (substring path 0 -1)))))))
    result))


;; main program
(defun template-file-not-found-hook ()
  "Called when a find-file command has not been able to find the specified
file in the current directory. Sees if it makes sense to offer to start it
based on a template."
  (condition-case nil
      (if (and (find-template-file)
               (y-or-n-p "Start with template file? "))
          (progn (buffer-disable-undo)
                 (insert-file (find-template-file))
                 (goto-char (point-min))

                 ;; Magically do the variable substitutions
                 (let ((the-list template-replacements-alist))
                   (while the-list
                     (goto-char (point-min))
                     (replace-string (car (car the-list)) ;?
                                     (funcall (cdr (car the-list)))
                                     nil)
                     (setq the-list (cdr the-list))))
                 (goto-char (point-min))
                 (buffer-enable-undo)
                 (set-buffer-modified-p nil)))
    ;; This is part of the condition-case; it catches the situation where
    ;; the user has hit C-g to abort the find-file (since they realized
    ;; that they didn't mean it) and deletes the buffer that has already
    ;; been created to go with that file, since it will otherwise become
    ;; mysterious clutter they may not even know about.
    ('quit (kill-buffer (current-buffer))
           (signal 'quit "Quit"))))

;; Install the above routine
(or (memq 'template-file-not-found-hook find-file-not-found-hooks)
    (setq find-file-not-found-hooks
          (append find-file-not-found-hooks '(template-file-not-found-hook)))
    )

(defun template-insert-include-once ()
  "Returns preprocessor directives such that the file will be included
only once during a compilation process which includes it an
abitrary number of times."
  (let ((name (file-name-nondirectory (buffer-file-name)))
        basename)
    (if (string-match ".h$" name)
        (progn
          (setq basename (upcase (substring name 0 -2)))
          (concat "#ifndef _H_"
                  basename
                  "\n#define _H_"
                  basename
                  "\n\n\n#endif  /* not defined _H_"
                  basename
                  " */\n"))
      "")))

(defun template-insert-java-package ()
  "Inserts an appropriate Java package directive based on the path to
the current file name (assuming that it is in the com, org or net
subtree). If no recognizable package path is found, inserts nothing."
  (let ((name (file-name-directory (buffer-file-name)))
        result)
    (if (string-match "/\\(com\\|org\\|net\\)/.*/$" name)
        (progn
          (setq result (substring name (+ (match-beginning 0) 1)
                                  (- (match-end 0) 1)))
          (while (string-match "/" result)
            (setq result (concat (substring result 0 (match-beginning 0))
                                 "."
                                 (substring result (match-end 0)))))
          (concat "package " result ";"))
      "")))

(defun template-insert-class-name ()
  "Inserts the name of the java class being defined in the current file,
based on the file name. If not a Java source file, inserts nothing."
  (let ((name (file-name-nondirectory (buffer-file-name))))
    (if (string-match "\\(.*\\)\\.java" name)
        (substring name (match-beginning 1) (match-end 1))
      "")))


;; The provide function works with `require` to allow
;; libraries to be loaded just once. When the function
;; (require 'template) is executed, Emacs checks whether
;; the feature "template" has ever been provided.
;; If it has, does nothing, otherwise, it calls load-library
;; to load it.
(provide 'template)
                 
                     
