;;;; swm-maildir-modeline.asd

(asdf:defsystem #:swm-maildir-modeline
  :description "Show the number of new maildir messages in the StumpWM modeline"
  :author "Joseph Mingrone <jrm@ftfl.ca>"
  :license "2-CLAUSE BSD (see COPYRIGHT file for details)"
  :depends-on (#:stumpwm)
  :serial t
  :components ((:file "package")
               (:file "swm-maildir-modeline")))
