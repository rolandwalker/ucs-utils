
;; requires and setup

(when load-file-name
  (setq pcache-directory (expand-file-name "test_output/" (file-name-directory load-file-name)))
  (setq package-enable-at-startup nil)
  (setq package-load-list '((pcache t)
                            (list-utils t)
                            (persistent-soft t)))
  (when (fboundp 'package-initialize)
    (package-initialize)))

(require 'list-utils)
(require 'persistent-soft)
(require 'ucs-utils)

;;; external libraries

(ert-deftest external-libraries-01 nil
  (should
   (featurep 'persistent-soft)))

(ert-deftest external-libraries-02 nil
  (should
   (featurep 'pcache)))


;;; ucs-utils--lookup

(ert-deftest ucs-utils--lookup-01 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils--lookup "MIDDLE DOT"))))

(ert-deftest ucs-utils--lookup-02 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils--lookup "Middle Dot"))))

(ert-deftest ucs-utils--lookup-03 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils--lookup "  Middle  Dot  "))))

(ert-deftest ucs-utils--lookup-04 nil
  (should-not
   (ucs-utils--lookup "Nonexistent Character")))

(ert-deftest ucs-utils--lookup-05 nil
  (should (eq (decode-char 'ucs #x3408)
   (ucs-utils--lookup "CJK Ideograph 3408"))))

(ert-deftest ucs-utils--lookup-06 nil
  (should-not
   (ucs-utils--lookup "CJK Compatibility Ideograph-FA6E")))


;;; ucs-utils-char

(ert-deftest ucs-utils-char-01 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils-char (decode-char 'ucs #xB7)))))

(ert-deftest ucs-utils-char-02 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils-char "Middle Dot"))))

(ert-deftest ucs-utils-char-03 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils-char "Middle Dot" ?.))))

(ert-deftest ucs-utils-char-04 nil
  (should (eq ?.
              (ucs-utils-char "Nonexistent Character" ?.))))

(ert-deftest ucs-utils-char-05 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils-char "Middle Dot" ?. 'identity))))

(ert-deftest ucs-utils-char-06 nil
  (should (eq ?.
              (ucs-utils-char "Middle Dot" ?. 'ignore))))

;; ambiguity in ucs-names
(ert-deftest ucs-utils-char-07 nil
  (should (eq (decode-char 'ucs #x021C)
              (ucs-utils-char "Latin Capital Letter Yogh"))))

;; new in Unicode 6.0 (covered in ucs-utils-6.0-delta.el)
(ert-deftest ucs-utils-char-08 nil
  (should (eq (decode-char 'ucs #x0841)
              (ucs-utils-char "Mandaic Letter Ab"))))

;; new in Unicode 6.1 (covered in ucs-utils-names-corrections)
(ert-deftest ucs-utils-char-09 nil
  (should (eq (decode-char 'ucs #x1F600)
              (ucs-utils-char "Grinning Face"))))

;; new in Unicode 6.1
(ert-deftest ucs-utils-char-10 nil
  (should (eq (decode-char 'ucs #xA7AA)
              (ucs-utils-char "Latin Capital Letter H with Hook"))))

;; plane 1 unicode-smp, new in Unicode 6.0
(ert-deftest ucs-utils-char-11 nil
  (should (eq (decode-char 'ucs #x1F624)
              (ucs-utils-char "Face with Look of Triumph"))))

;; plane 14 unicode-ssp
(ert-deftest ucs-utils-char-12 nil
  (should (eq (decode-char 'ucs #xE0154)
              (ucs-utils-char "Variation Selector-101"))))

;; new in Unicode 6.2 (covered in ucs-utils-names-corrections)
(ert-deftest ucs-utils-char-13 nil
  (should (eq (decode-char 'ucs #x20BA)
              (ucs-utils-char "Turkish Lira Sign"))))

;; new in Unicode 6.3 (covered in ucs-utils-names-corrections)
(ert-deftest ucs-utils-char-14 nil
  (should (eq (decode-char 'ucs #x2066)
              (ucs-utils-char "Left-to-Right Isolate"))))

;; large integer is not a character
(ert-deftest ucs-utils-char-15 nil
  (should-not (ucs-utils-char 35252544)))

;; not covered by `ucs-names'
(ert-deftest ucs-utils-char-16 nil
  (should (eq (decode-char 'ucs #x3408)
              (ucs-utils-char "CJK Ideograph 3408"))))

;; compensate for Emacs bug
(ert-deftest ucs-utils-char-17 nil
  (should-not
   (ucs-utils-char "CJK Compatibility Ideograph-FA6E")))

;;; ucs-utils-vector-flatten

(ert-deftest ucs-utils-vector-flatten-01 nil
  (should (equal '[1 2 3]
                 (ucs-utils-vector-flatten '[1 2 3]))))

(ert-deftest ucs-utils-vector-flatten-02 nil
  (should (equal '[1 2 3 4 5 6 7]
                 (ucs-utils-vector-flatten '[1 2 [3 4 5] 6 7]))))

(ert-deftest ucs-utils-vector-flatten-03 nil
  (should (equal '[1 2 3 4 5 6 7]
                 (ucs-utils-vector-flatten '[1 2 [3 4 5 [6 7]]]))))

(ert-deftest ucs-utils-vector-flatten-04 nil
  (should (equal '[1 2 51 52 53]
                 (ucs-utils-vector-flatten '[1 2 "345"]))))

(ert-deftest ucs-utils-vector-flatten-05 nil
  (should (equal '[1 2 (3 4 5) 6 7]
                 (ucs-utils-vector-flatten '[1 2 (3 4 5) 6 7]))))


;;; ucs-utils-prettify-ucs-string

(ert-deftest ucs-utils-prettify-ucs-string-01 nil
  (should (equal "Face with Look of Triumph"
                 (ucs-utils-prettify-ucs-string "FACE WITH LOOK OF TRIUMPH"))))

(ert-deftest ucs-utils-prettify-ucs-string-02 nil
  (should (equal "Fleur-de-Lis"
                 (ucs-utils-prettify-ucs-string "FLEUR-DE-LIS"))))

(ert-deftest ucs-utils-prettify-ucs-string-03 nil
  (should (equal "Logical AND"
                 (ucs-utils-prettify-ucs-string "LOGICAL AND"))))

(ert-deftest ucs-utils-prettify-ucs-string-04 nil
  (should (equal "Logical AND with Dot Above"
                 (ucs-utils-prettify-ucs-string "LOGICAL AND WITH DOT ABOVE"))))

(ert-deftest ucs-utils-prettify-ucs-string-05 nil
  (should (equal "Six-per-Em Space"
                 (ucs-utils-prettify-ucs-string "SIX-PER-EM SPACE"))))

(ert-deftest ucs-utils-prettify-ucs-string-06 nil
  (should (equal "CJK Stroke P"
                 (ucs-utils-prettify-ucs-string "CJK STROKE P"))))


;;; ucs-utils-pretty-name

(ert-deftest ucs-utils-pretty-name-01 nil
  (should (equal "Middle Dot"
                 (ucs-utils-pretty-name (decode-char 'ucs #xB7)))))

;; new in Unicode 6.0
(ert-deftest ucs-utils-pretty-name-02 nil
  (should (equal "Pensive Face"
                 (ucs-utils-pretty-name (decode-char 'ucs #x1F614)))))

(ert-deftest ucs-utils-pretty-name-03 nil
  (should (equal "#xF0000"
                 (ucs-utils-pretty-name (decode-char 'ucs #xf0000)))))

(ert-deftest ucs-utils-pretty-name-04 nil
  (should-not
   (ucs-utils-pretty-name (decode-char 'ucs #xF0000) 'no-hex)))

;; new in Unicode 6.2
(ert-deftest ucs-utils-pretty-name-05 nil
  (should (equal "Turkish Lira Sign"
                 (ucs-utils-pretty-name (decode-char 'ucs #x20BA)))))

;; new in Unicode 6.3
(ert-deftest ucs-utils-pretty-name-06 nil
  (should (equal "Left-to-Right Isolate"
                 (ucs-utils-pretty-name (decode-char 'ucs #x2066)))))

;; large integer is not a character
(ert-deftest ucs-utils-pretty-name-07 nil
  (should-not (ucs-utils-pretty-name 35252544)))


;;; ucs-utils-all-prettified-names

(ert-deftest ucs-utils-all-prettified-names-01 nil
  (should
   (> (length (ucs-utils-all-prettified-names)) 30000)))

(ert-deftest ucs-utils-all-prettified-names-02 nil
  (should
   (> (length (ucs-utils-all-prettified-names t t)) 30000)))

(ert-deftest ucs-utils-all-prettified-names-03 nil
  (should
   (> (length (member "Middle_Dot" (ucs-utils-all-prettified-names))) 0)))


;;; ucs-utils-first-existing-char

(ert-deftest ucs-utils-first-existing-char-01 nil
  (should (eq (decode-char 'ucs #xB7)
              (ucs-utils-first-existing-char '("Nonexistent Character 1" "Nonexistent Character 2" "Middle Dot")))))

(ert-deftest ucs-utils-first-existing-char-02 nil
  (should (eq ?.
              (ucs-utils-first-existing-char '("Nonexistent Character 1" "Nonexistent Character 2" ?.)))))


;;; ucs-utils-vector

(ert-deftest ucs-utils-vector-01 nil
  (should (equal '[?.]
                 (ucs-utils-vector ?.))))

(ert-deftest ucs-utils-vector-02 nil
  (should (equal '[#xB7]
                 (ucs-utils-vector "Middle Dot"))))

(ert-deftest ucs-utils-vector-03 nil
  (should (equal '[#xB7]
                 (ucs-utils-vector '("Middle Dot")))))

(ert-deftest ucs-utils-vector-04 nil
  (should (equal '[#xB7 ?a ?b]
                 (ucs-utils-vector '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))))

(ert-deftest ucs-utils-vector-05 nil
  (should (equal '[#xB7 ?a ?b]
                 (ucs-utils-vector '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'identity))))

(ert-deftest ucs-utils-vector-06 nil
  (should (equal '[?c ?d ?e]
                 (ucs-utils-vector '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'ignore))))

(ert-deftest ucs-utils-vector-07 nil
  (should (equal '[#xB7 ?d ?b]
                 (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))))

(ert-deftest ucs-utils-vector-08 nil
  (should (equal '[#xB7 nil ?b]
                 (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   nil))))

(ert-deftest ucs-utils-vector-09 nil
  (should (equal '[#xB7 ?b]
                 (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   'drop))))

(ert-deftest ucs-utils-vector-10 nil
  (should-error
   (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                     'error)))

(ert-deftest ucs-utils-vector-11 nil
  (should (equal '[#xB7 ?. ?. ?. ?b]
                 (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   '["Latin Small Letter C" ["..."] "Latin Small Letter E"]))))

(ert-deftest ucs-utils-vector-12 nil
  (should (equal '[#xB7 ["..."] ?b]
                 (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   '["Latin Small Letter C" ["..."] "Latin Small Letter E"] nil 'no-flatten))))

(ert-deftest ucs-utils-vector-13 nil
  (should (equal '[#xB7 nil ?b]
                 (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   '["Latin Small Letter C" [nil] "Latin Small Letter E"]))))


;;; ucs-utils-string

(ert-deftest ucs-utils-string-01 nil
  (should (equal "."
                 (ucs-utils-string ?.))))

(ert-deftest ucs-utils-string-02 nil
  (should (equal "·"
                 (ucs-utils-string "Middle Dot"))))

(ert-deftest ucs-utils-string-03 nil
  (should (equal "·"
                 (ucs-utils-string '("Middle Dot")))))

(ert-deftest ucs-utils-string-04 nil
  (should (equal "·ab"
                 (ucs-utils-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))))

(ert-deftest ucs-utils-string-05 nil
  (should (equal "·ab"
                 (ucs-utils-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'identity))))

(ert-deftest ucs-utils-string-06 nil
  (should (equal "cde"
                 (ucs-utils-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'ignore))))

(ert-deftest ucs-utils-string-07 nil
  (should (equal "·db"
                 (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))))

(ert-deftest ucs-utils-string-08 nil
  (should (equal "·b"
                 (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   nil))))

(ert-deftest ucs-utils-string-09 nil
  (should (equal "·b"
                 (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   'drop))))

(ert-deftest ucs-utils-string-10 nil
  (should-error
   (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                     'error)))

(ert-deftest ucs-utils-string-11 nil
  (should (equal "·...b"
                 (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   '["Latin Small Letter C" ["..."] "Latin Small Letter E"]))))

(ert-deftest ucs-utils-string-12 nil
  (should (equal "·b"
                 (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                   '["Latin Small Letter C" [nil] "Latin Small Letter E"]))))


;;; ucs-utils-intact-string

(ert-deftest ucs-utils-intact-string-01 nil
  (should (equal "."
                 (ucs-utils-intact-string ?. "F"))))

(ert-deftest ucs-utils-intact-string-02 nil
  (should (equal "·"
                 (ucs-utils-intact-string "Middle Dot" "."))))

(ert-deftest ucs-utils-intact-string-03 nil
  (should (equal "·"
                 (ucs-utils-intact-string '("Middle Dot") "."))))

(ert-deftest ucs-utils-intact-string-04 nil
  (should (equal "·ab"
                 (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                          "cde"))))

(ert-deftest ucs-utils-intact-string-05 nil
  (should (equal "·ab"
                 (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                          "cde"))))

(ert-deftest ucs-utils-intact-string-06 nil
  (should (equal "·ab"
                 (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                          "cde" 'identity))))

(ert-deftest ucs-utils-intact-string-07 nil
  (should (equal "cde"
                 (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                                          "cde" 'ignore))))

(ert-deftest ucs-utils-intact-string-08 nil
  (should (equal "cde"
                 (ucs-utils-intact-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                          "cde"))))

(ert-deftest ucs-utils-intact-string-09 nil
  (should (equal "c...e"
                 (ucs-utils-intact-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                          "c...e"))))

(ert-deftest ucs-utils-intact-string-10 nil
  (should (equal "cde"
                 (ucs-utils-intact-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                                          "cde"))))


;;; ucs-utils-subst-char-in-region

(ert-deftest ucs-utils-subst-char-in-region-01 nil
  (should (equal "testing..."
                 (with-temp-buffer
                   (goto-char (point-min))
                   (insert "testing···\n")
                   (goto-char (point-min))
                   (ucs-utils-subst-char-in-region (point-min) (line-end-position) (ucs-utils-char "Middle Dot") ?.)
                   (buffer-substring-no-properties (point-min) (line-end-position))))))

(ert-deftest ucs-utils-subst-char-in-region-02 nil
  (should (equal "testing..."
                 (with-temp-buffer
                   (goto-char (point-min))
                   (insert "testing···\n")
                   (goto-char (point-min))
                   (ucs-utils-subst-char-in-region (point-min) (line-end-position) "Middle Dot" ?.)
                   (buffer-substring-no-properties (point-min) (line-end-position))))))

;; todo undo does not work
(ert-deftest ucs-utils-subst-char-in-region-03 nil
  :expected-result :failed
  (should (equal "testing..."
                 (with-temp-buffer
                   (goto-char (point-min))
                   (insert "testing···\n")
                   (goto-char (point-min))
                   (ucs-utils-subst-char-in-region (point-min) (line-end-position) (ucs-utils-char "Middle Dot") ?.)
                   (undo 1)
                   (buffer-substring-no-properties (point-min) (line-end-position))))))

(ert-deftest ucs-utils-subst-char-in-region-04 nil
  :expected-result :failed
  (should (equal "testing..."
                 (with-temp-buffer
                   (goto-char (point-min))
                   (insert "testing···\n")
                   (goto-char (point-min))
                   (ucs-utils-subst-char-in-region (point-min) (line-end-position) (ucs-utils-char "Middle Dot") ?. 'noundo)
                   (undo 1)
                   (buffer-substring-no-properties (point-min) (line-end-position))))))


;;; ucs-utils-eval

(ert-deftest ucs-utils-eval-01 nil
  (should (equal "Middle Dot"
                 (with-temp-buffer
                   (goto-char (point-min))
                   (insert "·\n")
                   (goto-char (point-min))
                   (ucs-utils-eval (point-min))))))

;; @@@ todo passes, but causes spurious output at end of test run
;;     in batch mode
(ert-deftest ucs-utils-eval-02 nil
  (should (equal "\"Middle Dot\""
                 (with-temp-buffer
                   (goto-char (point-min))
                   (insert "·\n")
                   (goto-char (point-min))
                   (ucs-utils-eval (point-min) '(16))
                   (buffer-substring-no-properties (point-min) (line-end-position))))))

;;; ucs-utils-ucs-insert

(ert-deftest ucs-utils-ucs-insert-01 nil
  (should (equal "···"
                 (with-temp-buffer
                   (goto-char (point-min))
                   (ucs-utils-ucs-insert (ucs-utils-char "Middle Dot") 3)
                   (insert "\n")
                   (goto-char (point-min))
                   (buffer-substring-no-properties (point-min) (line-end-position))))))

(ert-deftest ucs-utils-ucs-insert-02 nil
  (should (equal "···"
                 (with-temp-buffer
                   (goto-char (point-min))
                   (ucs-utils-ucs-insert "Middle Dot" 3)
                   (insert "\n")
                   (goto-char (point-min))
                   (buffer-substring-no-properties (point-min) (line-end-position))))))

;;
;; Emacs
;;
;; Local Variables:
;; indent-tabs-mode: nil
;; mangle-whitespace: t
;; require-final-newline: t
;; coding: utf-8
;; byte-compile-warnings: (not cl-functions)
;; End:
;;

;;; ucs-utils-test.el ends here
