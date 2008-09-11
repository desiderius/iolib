;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;;;
;;; --- Device common functions.
;;;

(in-package :io.zeta-streams)

;;;-------------------------------------------------------------------------
;;; Device Classes
;;;-------------------------------------------------------------------------

(defclass device ()
  ((handle :initarg :handle :accessor handle-of)
   (readable :initarg :readable :accessor device-readablep)
   (writeable :initarg :writeable :accessor device-writeablep)
   (seekable :initarg :seekable :accessor device-seekablep)))

(defclass direct-device (device) ())

(defclass memory-buffer-device (direct-device) ())


;;;-------------------------------------------------------------------------
;;; Relinquish I/O resources
;;;-------------------------------------------------------------------------

(defgeneric relinquish (device &rest args &key abort))


;;;-------------------------------------------------------------------------
;;; Generic functions
;;;-------------------------------------------------------------------------

(defgeneric device-read (device vector &key start end timeout))

(defgeneric device-write (device vector &key start end timeout))

(defgeneric device-position (device))

(defgeneric (setf device-position) (position device &optional from))

(defgeneric device-length (device))

(defgeneric device-poll-input (device &key timeout))

(defgeneric device-poll-output (device &key timeout))

;;; Internal functions

(defgeneric device-open (device &rest initargs))

(defgeneric device-read/non-blocking (device vector start end))

(defgeneric device-read/timeout (device vector start end timeout))

(defgeneric device-write/non-blocking (device vector start end))

(defgeneric device-write/timeout (device vector start end timeout))


;;;-------------------------------------------------------------------------
;;; Helper macros
;;;-------------------------------------------------------------------------

(defmacro with-device ((name) &body body)
  `(let ((*device* ,name))
     (declare (special *device*))
     ,@body))


;;;-------------------------------------------------------------------------
;;; Default no-op methods
;;;-------------------------------------------------------------------------

(defmethod device-position ((device device))
  (values nil))

(defmethod (setf device-position) (position (device device) &optional from)
  (declare (ignore position from))
  (values nil))

(defmethod device-length ((device device))
  (values nil))


;;;-------------------------------------------------------------------------
;;; Default DEVICE-READ
;;;-------------------------------------------------------------------------

(defmethod device-read :around ((device device) vector &key
                                (start 0) end timeout)
  (check-bounds vector start end)
  (if (= start end)
      0
      (call-next-method device vector :start start
                        :end end :timeout timeout)))

(defmethod device-read ((device device) vector &key start end timeout)
  (if (and timeout (zerop timeout))
      (device-read/non-blocking device vector start end)
      (device-read/timeout device vector start end timeout)))


;;;-------------------------------------------------------------------------
;;; Default DEVICE-WRITE
;;;-------------------------------------------------------------------------

(defmethod device-write :around ((device device) vector &key
                                 (start 0) end timeout)
  (check-bounds vector start end)
  (if (= start end)
      0
      (call-next-method device vector :start start
                        :end end :timeout timeout)))

(defmethod device-write ((device device) vector &key start end timeout)
  (if (and timeout (zerop timeout))
      (device-write/non-blocking device vector start end)
      (device-write/timeout device vector start end timeout)))
