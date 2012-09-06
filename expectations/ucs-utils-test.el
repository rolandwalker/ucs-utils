
;; For GNU Emacs 23.x, the following libraries should be copied
;; to this directory before running tests:
;;
;;    pcache.el
;;    persistent-soft.el
;;
;; For Emacs 24.1 and above, external libraries will be found
;; automatically if they were installed by package.el.

(setq pcache-directory (expand-file-name "pcache/" (file-name-directory load-file-name)))

(setq package-enable-at-startup nil)
(setq package-load-list '((pcache t)
                          (persistent-soft t)))
(when (fboundp 'package-initialize)
  (package-initialize))

(require 'persistent-soft)
(require 'ucs-utils)

(expectations

  (desc "external libraries")

  (expect t
    (featurep 'persistent-soft))

  (expect t
    (featurep 'pcache)))

(expectations

  (desc "ucs-utils--lookup")

  (expect (decode-char 'ucs #xB7)
    (ucs-utils--lookup "MIDDLE DOT"))

  (expect (decode-char 'ucs #xB7)
    (ucs-utils--lookup "Middle Dot"))

  (expect (decode-char 'ucs #xB7)
    (ucs-utils--lookup "  Middle  Dot  "))

  (expect nil
    (ucs-utils--lookup "Nonexistent Character")))


(expectations

  (desc "ucs-utils-char")

  (expect (decode-char 'ucs #xB7)
    (ucs-utils-char (decode-char 'ucs #xB7)))

  (expect (decode-char 'ucs #xB7)
    (ucs-utils-char "Middle Dot"))

  (expect (decode-char 'ucs #xB7)
    (ucs-utils-char "Middle Dot" ?.))

  (expect ?.
    (ucs-utils-char "Nonexistent Character" ?.))

  (expect (decode-char 'ucs #xB7)
    (ucs-utils-char "Middle Dot" ?. 'identity))

  (expect ?.
    (ucs-utils-char "Middle Dot" ?. 'ignore))

  ;; ambiguity in ucs-names
  (expect (decode-char 'ucs #x021C)
    (ucs-utils-char "Latin Capital Letter Yogh"))

  ;; new in Unicode 6.0
  (expect (if (< emacs-major-version 24) nil (decode-char 'ucs #x0841))
    (ucs-utils-char "Mandaic Letter Ab"))

  ;; new in Unicode 6.1 (covered in ucs-utils-names-corrections)
  (expect (decode-char 'ucs #x1F600)
    (ucs-utils-char "Grinning Face"))

  ;; new in Unicode 6.1
  (expect (decode-char 'ucs #xA7AA)
    (ucs-utils-char "Latin Capital Letter H with Hook"))

  ;; plane 1 unicode-smp, new in Unicode 6.0
  (expect (if (< emacs-major-version 24) nil (decode-char 'ucs #x1F624))
    (ucs-utils-char "Face with Look of Triumph"))

  ;; plane 14 unicode-ssp
  (expect (decode-char 'ucs #xE0154)
    (ucs-utils-char "Variation Selector-101")))


(expectations

  (desc "ucs-utils-vector-flatten")

  (expect '[1 2 3]
    (ucs-utils-vector-flatten '[1 2 3]))

  (expect '[1 2 3 4 5 6 7]
    (ucs-utils-vector-flatten '[1 2 [3 4 5] 6 7]))

  (expect '[1 2 3 4 5 6 7]
    (ucs-utils-vector-flatten '[1 2 [3 4 5 [6 7]]]))

  (expect '[1 2 51 52 53]
    (ucs-utils-vector-flatten '[1 2 "345"]))

  (expect '[1 2 (3 4 5) 6 7]
    (ucs-utils-vector-flatten '[1 2 (3 4 5) 6 7])))


(expectations

  (desc "ucs-utils-prettify-ucs-string")

  (expect "Face with Look of Triumph"
    (ucs-utils-prettify-ucs-string "FACE WITH LOOK OF TRIUMPH"))

  (expect "Fleur-de-Lis"
    (ucs-utils-prettify-ucs-string "FLEUR-DE-LIS"))

  (expect "Logical AND"
    (ucs-utils-prettify-ucs-string "LOGICAL AND"))

  (expect "Logical AND with Dot Above"
    (ucs-utils-prettify-ucs-string "LOGICAL AND WITH DOT ABOVE"))

  (expect "Six-per-Em Space"
    (ucs-utils-prettify-ucs-string "SIX-PER-EM SPACE"))

  (expect "CJK Stroke P"
    (ucs-utils-prettify-ucs-string "CJK STROKE P")))


(expectations

  (desc "ucs-utils-pretty-name")

  (expect "Middle Dot"
    (ucs-utils-pretty-name (decode-char 'ucs #xB7)))

  ;; new in Unicode 6.0
  (expect (if (< emacs-major-version 24) "#x1F614" "Pensive Face")
    (ucs-utils-pretty-name (decode-char 'ucs #x1F614)))

  (expect "#xF0000"
    (ucs-utils-pretty-name (decode-char 'ucs #xf0000)))

  (expect nil
    (ucs-utils-pretty-name (decode-char 'ucs #xF0000) 'no-hex)))


(expectations

  (desc "ucs-utils-all-prettified-names")

  (expect t
    (> (length (ucs-utils-all-prettified-names)) 30000))

  (expect t
    (> (length (ucs-utils-all-prettified-names t t)) 30000))

  (expect t
    (> (length (member "Middle_Dot" (ucs-utils-all-prettified-names))) 0)))


(expectations

  (desc "ucs-utils-first-existing-char")

  (expect (decode-char 'ucs #xB7)
    (ucs-utils-first-existing-char '("Nonexistent Character 1" "Nonexistent Character 2" "Middle Dot")))

  (expect ?.
    (ucs-utils-first-existing-char '("Nonexistent Character 1" "Nonexistent Character 2" ?.))))


(expectations

  (desc "ucs-utils-vector")

  (expect '[?.]
    (ucs-utils-vector ?.))

  (expect '[#xB7]
    (ucs-utils-vector "Middle Dot"))

  (expect '[#xB7]
    (ucs-utils-vector '("Middle Dot")))

  (expect '[#xB7 ?a ?b]
    (ucs-utils-vector '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))

  (expect '[#xB7 ?a ?b]
    (ucs-utils-vector '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'identity))

  (expect '[?c ?d ?e]
    (ucs-utils-vector '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'ignore))

  (expect '[#xB7 ?d ?b]
    (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))

  (expect '[#xB7 nil ?b]
    (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      nil))

  (expect '[#xB7 ?b]
    (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      'drop))

  (expect (error)
    (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      'error))

  (expect '[#xB7 ?. ?. ?. ?b]
    (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      '["Latin Small Letter C" ["..."] "Latin Small Letter E"]))

  (expect '[#xB7 ["..."] ?b]
    (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      '["Latin Small Letter C" ["..."] "Latin Small Letter E"] nil 'no-flatten))

  (expect '[#xB7 nil ?b]
    (ucs-utils-vector '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      '["Latin Small Letter C" [nil] "Latin Small Letter E"])))


(expectations

  (desc "ucs-utils-string")

  (expect "."
    (ucs-utils-string ?.))

  (expect "·"
    (ucs-utils-string "Middle Dot"))

  (expect "·"
    (ucs-utils-string '("Middle Dot")))

  (expect "·ab"
    (ucs-utils-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))

  (expect "·ab"
    (ucs-utils-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'identity))

  (expect "cde"
    (ucs-utils-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E") 'ignore))

  (expect "·db"
    (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      '("Latin Small Letter C" "Latin Small Letter D" "Latin Small Letter E")))

  (expect "·b"
    (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      nil))

  (expect "·b"
    (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      'drop))

  (expect (error)
    (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      'error))

  (expect "·...b"
    (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      '["Latin Small Letter C" ["..."] "Latin Small Letter E"]))

  (expect "·b"
    (ucs-utils-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                      '["Latin Small Letter C" [nil] "Latin Small Letter E"])))


(expectations

  (desc "ucs-utils-intact-string")

  (expect "."
    (ucs-utils-intact-string ?. "F"))

  (expect "·"
    (ucs-utils-intact-string "Middle Dot" "."))

  (expect "·"
    (ucs-utils-intact-string '("Middle Dot") "."))

  (expect "·ab"
    (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                             "cde"))

  (expect "·ab"
    (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                             "cde"))

  (expect "·ab"
    (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                             "cde" 'identity))

  (expect "cde"
    (ucs-utils-intact-string '("Middle Dot" "Latin Small Letter A" "Latin Small Letter B")
                             "cde" 'ignore))

  (expect "cde"
    (ucs-utils-intact-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                             "cde"))

  (expect "c...e"
    (ucs-utils-intact-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                             "c...e"))

  (expect "cde"
    (ucs-utils-intact-string '("Middle Dot" "Nonexistent Character" "Latin Small Letter B")
                             "cde")))


(expectations

  (desc "ucs-utils-subst-char-in-region")

  (expect "testing..."
    (switch-to-buffer "*scratch*")
    (goto-char (point-min))
    (insert "testing···\n")
    (goto-char (point-min))
    (ucs-utils-subst-char-in-region (point-min) (line-end-position) (ucs-utils-char "Middle Dot") ?.)
    (buffer-substring-no-properties (point-min) (line-end-position)))

  (expect "testing..."
    (switch-to-buffer "*scratch*")
    (goto-char (point-min))
    (insert "testing···\n")
    (goto-char (point-min))
    (ucs-utils-subst-char-in-region (point-min) (line-end-position) "Middle Dot" ?.)
    (buffer-substring-no-properties (point-min) (line-end-position))))

;; todo undo does not work
;;
;; (expect "testing···"
;;   (switch-to-buffer "*scratch*")
;;   (goto-char (point-min))
;;   (insert "testing···\n")
;;   (goto-char (point-min))
;;   (ucs-utils-subst-char-in-region (point-min) (line-end-position) (ucs-utils-char "Middle Dot") ?.)
;;   (undo 1)
;;   (buffer-substring-no-properties (point-min) (line-end-position)))
;;
;; (expect "testing..."
;;   (switch-to-buffer "*scratch*")
;;   (goto-char (point-min))
;;   (insert "testing···\n")
;;   (goto-char (point-min))
;;   (ucs-utils-subst-char-in-region (point-min) (line-end-position) (ucs-utils-char "Middle Dot") ?. 'noundo)
;;   (undo 1)
;;   (buffer-substring-no-properties (point-min) (line-end-position)))


(expectations

  (desc "ucs-utils-eval")

  (expect "Middle Dot"
    (switch-to-buffer "*scratch*")
    (goto-char (point-min))
    (insert "·\n")
    (goto-char (point-min))
    (ucs-utils-eval (point-min)))

  (expect "\"Middle Dot\""
    (switch-to-buffer "*scratch*")
    (goto-char (point-min))
    (insert "·\n")
    (goto-char (point-min))
    (ucs-utils-eval (point-min) '(16))
    (buffer-substring-no-properties (point-min) (line-end-position))))


(expectations

  (desc "ucs-utils-ucs-insert")

  (expect "···"
    (switch-to-buffer "*scratch*")
    (goto-char (point-min))
    (ucs-utils-ucs-insert (ucs-utils-char "Middle Dot") 3)
    (insert "\n")
    (goto-char (point-min))
    (buffer-substring-no-properties (point-min) (line-end-position)))

  (expect "···"
    (switch-to-buffer "*scratch*")
    (goto-char (point-min))
    (ucs-utils-ucs-insert "Middle Dot" 3)
    (insert "\n")
    (goto-char (point-min))
    (buffer-substring-no-properties (point-min) (line-end-position))))

;;
;; Emacs
;;
;; Local Variables:
;; indent-tabs-mode: nil
;; mangle-whitespace: t
;; require-final-newline: t
;; coding: utf-8
;; byte-compile-warnings: (not cl-functions redefine)
;; End:
;;

;;; ucs-utils-test.el ends here
