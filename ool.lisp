;;; Surname Name ID


;;;; Hash Table Used To Store Classes Informations
(defparameter *classes-specs* (make-hash-table))


;;;; Function Used To Insert The class-spec To The  Hash Table
(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) class-spec))


;;;; Function That Recovers The class-spec From The Hash Table
;;;; Uses The Function: gethash key hashtable
;;;; Wich Finds The Object In hashtable With key As Key
;;;; If Key Not Found, Returns nil
(defun get-class-spec (name)
  (gethash name *classes-specs*))


;;;; Input Checking For The Slots
(defun check-slot (slot-values)
  (if (null slot-values) ;; slot-values Is Empty, Ok
      T
      (if (symbolp (first slot-values)) ;; The First Element Must Be A Symbol
	  (check-slot (rest (rest slot-values))) ;; Check From The Third Element
	  Nil)))


;;;; Input Checking For The Class
(defun input-class-check (name parent slot-values)
  (if (symbolp name) ;; Name Must Be A Symbol
      (if (symbolp parent) ;; Parent Must Be A Symbol
	  (if (not (atomp slot-values)) ;; Slot Values Must Be A List
	      (check-slot slot-values)
	      Nil)
	  Nil)
      Nil))


;;;; Function Used To Define A New Class
(defun define-class (class-name parent slot-values)
  (if (input-class-check class-name parent slot-values)  
      (if (get-class-spec class-name) ;; Checks If The Class Is Already  Defined
	(add-class-spec slot-value)
	(error "Class Already Defined !!!"))
      (error "Wrong Input!!!")))
	
