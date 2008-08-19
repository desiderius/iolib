;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; indent-tabs-mode: nil -*-
;;;
;;; --- Package definition.
;;;

(in-package :common-lisp-user)

(defpackage :iolib.base
  (:use #:common-lisp :alexandria)
  (:shadow #:defun #:defmethod
           #:defmacro #:define-compiler-macro)
  (:export
   ;; RETURN*
   #:return* #:lambda* #:defun #:defmethod
   #:defmacro #:define-compiler-macro
   ;; DEFOBSOLETE
   #:deprecation-warning
   #:deprecation-warning-function-name
   #:deprecation-warning-type
   #:deprecation-warning-reason
   #:function-name #:function-name-p
   #:defobsolete))

(flet ((gather-external-symbols (&rest packages)
         (let ((symbols (make-hash-table :test #'eq)))
           (with-package-iterator (iterator packages :external)
             (loop (multiple-value-bind (morep symbol) (iterator)
                     (unless morep (return))
                     (setf (gethash (alexandria:ensure-symbol symbol :iolib.base) symbols) t))))
           (alexandria:hash-table-keys symbols))))
  (export (gather-external-symbols :common-lisp :alexandria :iolib.base)
          :iolib.base))