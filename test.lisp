;;;; Test File

;;;; Loading File With OOL API
(load "ool.lisp")


;;;; Definition Of A Class Person
(define-class 'person nil 'name "Eve" 'age "undefined")


;;;; Definition Of A Class Students, Subclass Of Person
(define-class 'student 'person 
  'name "Eva Lu Ator"
  'university "Berkeley"
  'talk '(method ()
	  (princ "My name is ")
	  (princ (get-slot this 'name))
	  (terpri)
	  (princ "My age is ")
	  (princ (get-slot this 'age)))

)


;;;; Istances Of Class Person
(defparameter *eve* (new 'person))
(defparameter *adam* (new 'person 'name "Adam"))


;;;; Instances Of Class Student
(defparameter *s1* (new 'student 
			'name "Eduardo De Filippo"
			'age 108))

(defparameter *s2* (new 'student 'adress "MyHome"))


;;;; Istances Ispection
(get-slot *eve* 'age)

(get-slot *adam* 'name)

(get-slot *s1* 'name)

(get-slot *s2* 'adress)


;;;; Methods Calling
;(talk *eve*)

;(talk *adam*)
			

	      
  
