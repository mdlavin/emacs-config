;;; javascript

;; The javascript snipets use some functions from 's' so require it
(require 's)
(require 'yasnippet)

(defun js-anon-method-p ()
  (save-excursion
    (word-search-backward "function")
    (looking-back "[,:\\[][ \n\t\r]*")))

(defun js-function-declaration-p ()
  (save-excursion
    (word-search-backward "function")
    (looking-back "[^ \n\t\r,:\\[][ \n\t\r]*")))

(defun js-in-var-decl-list-p ()
  (save-excursion
    (move-to-column yas--start-column)
    (looking-back ",[ \n\t\r]*")))

(defun snippet--function-punctuation ()
  (if (js-anon-method-p)
      (when (not (looking-at "[ \n\t\r]*[}\\]]"))
        (insert ","))
      (insert ";")))

(defun snippet--function-name ()
  (if (js-anon-method-p) "" "name"))

(defun snippet--require-prefix ()
  (if (js-in-var-decl-list-p) "" "var "))

(defun snippet--require-trailer ()
  (if (js-in-var-decl-list-p) "," ";"))
