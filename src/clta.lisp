#|
  This file is a part of clta project.
  Copyright (c) 2014 κeen
|#

(in-package :cl-user)
(defpackage clta
  (:use
   :cl
   :clta.parse
   :clta.pass
   :clta.backend
   :clta.backend.stream
   :clta.util)
  (:import-from :alexandria
                :if-let)
  (:export :compile-template-string
           :render))
(in-package :clta)

(defun compile-template-string (backend str env)
  (emit-lambda backend (apply-passes (parse-template-string str) env)))

(defun render (template &rest args)
  (let* ((backend-given (getf args :backend))
         (backend (or backend-given (make-backend :stream))))
    (when backend-given
      (remf args :backend))
    (apply (compile-template-string backend template ())
           (if backend-given
               args
               (cons *standard-output* args)))))


#+(or)
(render "Hello {{var name}}!!"
        :name "κeen")

#+(or)
(let ((renderer (compile-template-string (make-backend :stream) "Hello {{var name}}!!" ())))
  (funcall renderer *standard-output* :name "κeen"))

