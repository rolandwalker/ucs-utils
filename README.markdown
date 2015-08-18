[![Build Status](https://secure.travis-ci.org/rolandwalker/ucs-utils.png?branch=master)](http://travis-ci.org/rolandwalker/ucs-utils)

# Overview

Utilities for Unicode characters in Emacs.

 * [Quickstart](#quickstart)
 * [Explanation](#explanation)
 * [See Also](#see-also)
 * [Compatibility and Requirements](#compatibility-and-requirements)

## Quickstart

```elisp
(require 'ucs-utils)
 
(ucs-utils-char "Middle Dot"         ; character to return
                ?.                   ; fallback if unavailable
                'char-displayable-p) ; test for character to pass
 
(ucs-utils-first-existing-char '("White Bullet"
                                 "Bullet Operator"
                                 "Circled Bullet"
                                 "Middle Dot"
                                 ?.) 'cdp)
 
(ucs-utils-string "Horizontal Ellipsis" '[["..."]])
```

## Explanation

This library provides utilities for manipulating Unicode
characters, with integrated ability to return fallback characters
when Unicode display is not possible.

Some ambiguities in Emacs' built-in Unicode data are resolved, and
character support is updated to Unicode 7.0.

There are three interactive commands:

	ucs-utils-ucs-insert        ; ucs-insert workalike using ido-completing-read
	ucs-utils-eval              ; the inverse of ucs-insert
	ucs-utils-install-aliases   ; install shorter aliases

The other functions are only useful from other Lisp code:

	ucs-utils-char
	ucs-utils-first-existing-char
	ucs-utils-vector
	ucs-utils-string
	ucs-utils-intact-string
	ucs-utils-pretty-name
	ucs-utils-read-char-by-name
	ucs-utils-subst-char-in-region

## See Also

 * <kbd>M-x</kbd> <kbd>customize-group</kbd> <kbd>RET</kbd> <kbd>ucs-utils</kbd> <kbd>RET</kbd>

<http://en.wikipedia.org/wiki/Universal_Character_Set>

## Compatibility and Requirements

	GNU Emacs version 25.1-devel     : not tested
	GNU Emacs version 24.5           : not tested
	GNU Emacs version 24.4           : yes
	GNU Emacs version 24.3           : yes
	GNU Emacs version 23.3           : yes (*)
	GNU Emacs version 22.3 and lower : no

(*) For full Emacs 23.x support, the library [ucs-utils-6.0-delta.el](http://github.com/rolandwalker/ucs-utils/blob/master/ucs-utils-6.0-delta.el) should also be installed.

Uses if present: [persistent-soft.el](http://github.com/rolandwalker/persistent-soft) (Recommended)
