;;; Surname Name ID


;;;; Hash Table Used To Store Classes Informations
(defparameter *classes-specs* (make-hash-table))



;;;; Function Used To Insert The class-spec To The  Hash Table
;;;; Return The Class Name
(defun add-class-spec (name class-spec)
  (setf (gethash name *classes-specs*) ;; Links The Class Name With The Class
	class-spec)                    ;; Definition And Puts Them In The Table
  (car (list name))) ;; Returns The Class Name



;;;; Function That Recovers The class-spec From The Hash Table
;;;; Uses The Function: gethash key hashtable
;;;; Wich Finds The Object In hashtable With key As Key
;;;; If Key Not Found, Returns nil
(defun get-class-spec (name)
  (gethash name *classes-specs*))



;;;; Find Slot
;;;; This Function Find The Slot-Name In The
;;;; List. Nil If Not Found
(defun find-slot (list-arg slot-name)
  (if (not (null list-arg)) ;; Instance Mustn't Be Nil
      (if (equal (first list-arg) 
		 slot-name) ;; Slot Found
	  (cons slot-name ;; Return (slot-name . slot-value)
		(second list-arg)) 
	  (find-slot (rest (rest list-arg)) slot-name)) ;; Recursive Step
      Nil))
      



;;;; Find Slot Parent
;;;; This Function Find The Slot-Name Recursively
;;;; In The Parents. Nil If Not Found
(defun find-slot-p (parent slot-name)
  (if (not (null parent)) ;; Parent  Mustn't Be Nil
      (if (not (null (get-class-spec parent))) ;; Parent Class Must Be Defined
	(let ((slotl (find-slot (rest (get-class-spec parent)) slot-name)))
	  (if (not (null slotl)) ;; Slot Musn't Be Null
	      slotl ;; Return Slot Value
	      (find-slot-p (first (get-class-spec parent)) ;; Try Looking In The
			   slot-name)))                    ;; Grandparent
	Nil)
      Nil))
      




;;;; Get Slot
(defun get-slot (instance slot-name)
  (if (and (not (null instance)) ;; Instance Mustn't Be Null
	   (symbolp slot-name)) ;; slot-name Must Be A Symbol
      (if (not (null (find-slot (rest instance) ;; Check If The Associated 
				slot-name)))    ;; slot-values Isn't Null
	  (cdr (find-slot (rest instance) ;; Return The Found slot-value
			  slot-name))
	  (let ((class-sp (get-class-spec (first instance))))
	    (if (not (null class-sp)) ;; Class Defined
		(if (not (null (find-slot (rest class-sp) ;; Look Into The 
					  slot-name))) ;; The Class
		    (cdr (find-slot (rest class-sp) ;; Slot Value Found, Return It
				    slot-name))
		    (let ((slot-par (find-slot-p (first class-sp) slot-name)))
		      (if (not (null slot-par)) ;; Look Into Parent Class 
			  (cdr slot-par)  ;; Slot Value Found, Return It
			  (error "Slot Not Found"))))
		(error "Slot Not Found"))))
      (error "Wrong Input")))




;;;; Input Checking For The Slots
(defun check-slot (slot-values)
  (if (null slot-values) ;; slot-values Is Empty, Return True
      T
      (if (symbolp (first slot-values)) ;; The First Element Must Be A Symbol
	  (check-slot (rest (rest slot-values))) ;; Check From Third Element
	  Nil)))



;;;; Input Checking For The Class
(defun input-class-check (name parent slot-values)
  (if (symbolp name) ;; Name Must Be A Symbol
      (if (symbolp parent) ;; Parent Must Be A Symbol
	  (if (not (atom slot-values)) ;; Slot Values Must Be A List
	       (if (evenp (length slot-values))
		   (check-slot slot-values)
		   Nil)
	      Nil)
	  Nil)
      Nil))




;;;; Rewrite Method 
;;;; This Function Add The Argument This To The Method
(defun rewrite-method (method-spec)
   (list 'lambda (append (list 'this)
		       (second method-spec))
	(cons 'progn (rest (rest method-spec)))))




;;;; Method-Process
;;;; Function Used To Process Methods, Rewriting Them To
;;;; Lisp Functions 
(defun method-process (method-name method-spec)
  (setf (fdefinition method-name) 
	(lambda (this &rest args)
	  (apply (get-slot this 
			   method-name)
		 (append (list this)
			 args))))	
  (eval (rewrite-method method-spec)))




;;;; Slot-Values-Proc
;;;; Modify The Slot-Values By Processing All The Methods
(defun slot-values-proc (slot-values)
  (if (null slot-values)
      ()
      (if (and (not (atom (second slot-values)))
	       (equal (car (second slot-values)) 
		     'method))
	  (append (list (first slot-values))
		  (list (method-process (first slot-values) 
					(second slot-values)))
		  (slot-values-proc (rest (rest slot-values))))
	  (append (list (first slot-values) 
			(second slot-values))
		  (slot-values-proc (rest (rest slot-values)))))))
	  



;;;; Define-Class
;;;; Function Used To Define A New Class
(defun define-class (class-name parent &rest slot-values)
  (if (input-class-check class-name parent slot-values)  
      (if (not (get-class-spec class-name)) ;; Check If Class Is Already Defined
	  (if (null parent) ;; Check If Orphan
	      (add-class-spec class-name ;; Add List To Hash Table 
			      (append (list parent) 
				      (slot-values-proc slot-values)))
	      (if (not (null (get-class-spec parent))) ;; Parent Class Defined
		  (add-class-spec class-name ;; Add List To Hash Table
				  (append (list parent) 
					  (slot-values-proc slot-values)))
		  (error "Parent Class Not Defined !!!")))
	(error "Class Already Defined !!!"))
      (error "Wrong Input!!!")))
	


;;;; New 
;;;; Instantiate A New Class Previously Defined
(defun new (class-name &rest slot-values)
  (if (symbolp class-name) ;; Class Name Must Be A Symbol
      (if (get-class-spec class-name) ;; The Class Must Be Defined
	  (if (evenp (length slot-values)) ;; NUmber Or Arguments Must Be Even
	      (if (check-slot slot-values) ;; Arguments Are Valid
		  (append (list class-name) ;; Create List With Name And
			  (slot-values-proc slot-values)) ;; Processed Slot
		  (error "Wrong Slot Values"))
	      (error "Wrong Slot Values"))
	  (error "Class Not Defined !!!"))
      (error "Wrong Class Name"))) 
		  
