[![Build Status](https://secure.travis-ci.org/rolandwalker/ucs-utils.png)](http://travis-ci.org/rolandwalker/ucs-utils)

Overview
=========

Utilities for Unicode characters in Emacs.

Quickstart
----------

```lisp
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

ucs-utils
---------

This library provides utilities for manipulating Unicode
characters, with integrated ability to return fallback characters
when Unicode display is not possible.

Some ambiguities in Emacs' built-in Unicode data are resolved, and
character support is updated to Unicode 6.1.

There are three interactive commands

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

See Also
---------

M-x customize-group RET ucs-utils RET

[http://en.wikipedia.org/wiki/Universal_Character_Set](http://en.wikipedia.org/wiki/Universal_Character_Set)

Compatibility and Requirements
------------------------------

Tested on GNU Emacs versions 23.3 and 24.1

For full Emacs 23.x support, the library `ucs-utils-6.0-delta.el`
should also be installed.

Uses if present: [persistent-soft.el](http://github.com/rolandwalker/persistent-soft) (Recommended)
