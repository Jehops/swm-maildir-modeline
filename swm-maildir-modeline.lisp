;; swm-maildir-modline.lisp
;;
;; Put %m in your modeline format string to show number of new mails
;;

(in-package #:swm-maildir-modeline)

(defvar *checking-flag* nil)
(defvar *host* "gly") ;; set the hostname to . for mail on the local host
(defvar *maildir-prev-time* 0)
(defvar *new-mail-count* "")
(defvar *port* "44422")
(defvar *path* "mail/new")
(defvar *user* "jrm")

(defun check-new-messages ()
  (sb-thread:make-thread
    (lambda ()
      (loop
	 (setf *new-mail-count*
	       (string-trim
		'(#\Space #\Tab #\Newline)
		(stumpwm::run-prog-collect-output
		 stumpwm::*shell-program* "-c"
		 (concatenate 'string "/usr/bin/ssh -p " *port*
			      " -x -o ConnectTimeout=1 " *user*
			      "@" *host* " 'ls " *path*
			      " | wc -l'"))))
      (sleep 60)))
    :name "check-new-messages-thread"))

(defun fmt-maildir-modeline (ml)
  "Return the number of new mails"
  (when (not *checking-flag*)
    (setf *checking-flag* t)
    (check-new-messages))
  ;; (declare (ignore ml))
  ;; (let ((now (/ (get-internal-real-time) internal-time-units-per-second)))
  ;;   (when (or (= 0 *maildir-prev-time*) (>= (- now *maildir-prev-time*) 60))
  ;;     (setf *maildir-prev-time* now)
  ;;     (sb-thread:make-thread
  ;;      (lambda ()
  ;; 	 (setf *new-mail-count*
  ;; 	       (string-trim
  ;; 		'(#\Space #\Tab #\Newline)
  ;; 		(stumpwm::run-prog-collect-output
  ;; 		 stumpwm::*shell-program* "-c"
  ;; 		 (concatenate 'string "/usr/bin/ssh -p " *port*
  ;; 			      " -x -o ConnectTimeout=1 " *user*
  ;; 			      "@" *host* " 'ls " *path*
  ;; 			      " | wc -l'"))))) :name "mail-thread")))
  (when (string= *new-mail-count* "0")
    (setf *new-mail-count* ""))
  (format nil "~a" *new-mail-count*))

;;(print (with-output-to-string (s) (run-prog stumpwm::*shell-program* :args (concatenate 'string "/usr/bin/ssh -p " *port* " " *user* "@" *host* " 'ls " *path* " | wc -l'") :output s :wait nil))

;; Install formatter
(stumpwm::add-screen-mode-line-formatter #\m #'fmt-maildir-modeline)
