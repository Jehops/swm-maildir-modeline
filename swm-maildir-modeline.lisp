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


(defun call-with-command-stream (fun command &rest arguments)
  "Run shell-comand COMMAND with ARGUMENTS as arguments. While the
command is running, call FUN with one argument, the stream
representing the ongoing output of the command. If the command exits
with nonzero status, signals an error. Like WITH-RUN-OUTPUT, but does
not collect all output in advance."
  (let ((process (stumpwm:run-program "~/local/bin/ml_mail.sh"
				     nil
				     :search t
				     :output :stream
				     :error *error-output*
				     :wait nil)))
    (let ((stream (sb-ext:process-output process)))
      (unwind-protect
	   (multiple-value-prog1
	       (funcall fun stream)
	     (sb-ext:process-wait process)
	     (let ((status (sb-ext:process-exit-code process)))
	       (unless (zerop status)
		 (error "Non-zero exit from ~S~{ ~S~}: ~D"
			command arguments
			status))))
	(when (open-stream-p stream)
	  (ignore-errors (close stream :abort t)))))))




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

(stumpwm::run-program "~/local/bin/ml_mail.sh"
				     nil
				     :search t
				     :output :stream
				     :error *error-output*
				     :wait nil)

