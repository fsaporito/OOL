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
  (if (null slot-values) ;; slot-values Is Empty, Return T
      T
      (if (symbolp (first slot-values)) ;; The First Element Must Be A Symbol
	  (check-slot (rest (rest slot-values))) ;; Check From The Third Element
	  Nil)))



;;;; Input Checking For The Class
(defun input-class-check (name parent slot-values)
  (if (symbolp name) ;; Name Must Be A Symbol
      (if (symbolp parent) ;; Parent Must Be A Symbol
	  (if (not (atom slot-values)) ;; Slot Values Must Be A List
	      (check-slot slot-values)
	      Nil)
	  Nil)
      Nil))



;;;; Function Used To Define A New Class
(defun define-class (class-name parent slot-values)
  (if (input-class-check class-name parent slot-values)  
      (if (get-class-spec class-name) ;; Checks If The Class Is Already Defined
	  (if (null parent) ;; Parent Class If Exists Must Be Defined
	      (add-class-spec class-name 
			      (append (list parent) 
				      slot-values))
	      (if (not (null get-class-spec parent))
		  (add-class-spec class-name 
				  (append (list parent) 
					  slot-values))
		  (error "Parent Class Not Defined !!!")))
	(error "Class Already Defined !!!"))
      (error "Wrong Input!!!")))
	


;;;; New, Instantiate A New Class
;;;; Previously Defined
(defun new (class-name slot-values)
  (if (symbolp class-name) 
      (if (get-class-spec class-name)
	  (if (check-slot slot-values)
	      (append (list class-name)
		      slot-values))
	      (error "Wrong Slot Values"))
	  (error "Class Not Defined !!!"))
      (error "Wrong Class Name")))


;;;; Find Slot In Instance
;;;; This Function Find The Slot-Name In The
;;;; Instance. Nil If Not Found
(defun find-slot-instance (instance slot-name)
  (if (not (null instance))
      (if (equal (second instance) slot-name)
	  (third instance)
	  (find-slot (rest (rest instance)) slot-name))
      Nil))
      


;;; Find Slot In Class
;;;; This Function Find The Slot-Name In The
;;;; Class. Nil If Not Found
(defun find-slot-class (class-name slot-name)
  (if (not (null class))
      (if (equal (second instance) slot-name)
	  (third instance)
	  (find-slot (rest (rest instance)) slot-name))
      Nil))



;;;; Get Slot
(defun get-slot (instance slot-name)
  (if (not (null instance)) ;; Instance Must Not Be Empty
      (if (symbolp slot-name) ;; slot-name Must Be A Symbol
	  (if (not (null (find-slot instance slot-name)))
	      (find-slot instance slot-name)
	      (if (get-class-spec (first instance))
		  (if (not (null (find-slot (get-class-spec (first instance)) 
					slot-name)))
		  
