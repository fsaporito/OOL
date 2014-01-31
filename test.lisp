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
	  (princ (get-slot this 'age))
	  (terpri)))


;;;; Definition Of A Class Pdh, Subclass Of Student
(define-class 'phd 'student 'subject "ComputerScience")


;;;; Istances Of Class Person
(defparameter *eve* (new 'person))
(defparameter *adam* (new 'person 'name "Adam"))


;;;; Instances Of Class Student
(defparameter *s1* (new 'student 
			'name "Eduardo De Filippo"
			'age 108))

(defparameter *s2* (new 'student 'adress "My Home"))


;;;; Instance Of Class Phd
(defparameter *me* (new 'phd 'name "Ernest" 'age "24"))


;;;; Istances Ispection
(get-slot *eve* 'age)

(get-slot *adam* 'name)

(get-slot *s1* 'name)

(get-slot *s1* 'age)

(get-slot *s2* 'name)

(get-slot *s2* 'age)

(get-slot *s2* 'adress)


;;;; Methods Calling
(princ "talk S1")
(terpri)
(talk *s1*)
(terpri)
(terpri)

(princ "talk S2")
(terpri)
(talk *s2*)
(terpri)
(terpri)

(princ "talk Me")
(terpri)
(talk *me*)
(terpri)
(terpri)



			

	      
  
