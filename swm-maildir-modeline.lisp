;; swm-maildir-modline.lisp
;;
;; Put %m in your modeline format string to show number of new mail messages
;;

(in-package #:swm-maildir-modeline)

(defvar *mail-stream* nil)
(defvar *new-mail-count* "")

(defun set-mail-stream ()
  (setf *mail-stream*
	(sb-ext:process-output
	 (sb-ext:run-program "ml_mail.sh" nil
			     :output :stream
			     :search t
			     :wait nil))))

(defun fmt-maildir-modeline (ml)
  "Return the number of new mails"
  (when (not *mail-stream*)
    (set-mail-stream))
  (when (listen *mail-stream*)
    (setf *new-mail-count* (read-line *mail-stream* nil "")))
  (when (string= *new-mail-count* "0")
    (setf *new-mail-count* ""))
  ;; (when (cl-ppcre::scan "^[^0-9]+" *new-mail-count*)
  ;;   (when (listen *mail-stream*)
  ;;     (read-line *mail-stream* nil ""))
  ;;   (setf *new-mail-count* "*!*"))
  (format nil "~a" *new-mail-count*))

;; Install formatter
(stumpwm::add-screen-mode-line-formatter #\m #'fmt-maildir-modeline)