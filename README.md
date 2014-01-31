OOL
===

Lisp implementation of a simple Object Oriented Language with single inheritance

===

This program implements the OOL language by saving the class definitions
in an hash-table. This is the hash table API:


*class-spec* 
Is the global variable where the hash-table is saved.


add-class-spec (name class-spec) 
Is the function that adds a new entry in the hash-table, composed by the class 
name and the class-spec, which is a list containing the class parent, the class
attributes with their default values and the class methods.

									
get-class-spec (name) 
this function recovers from the hash-table the Class-Spec associated to the 
class-name passed as argument.
						 

===

						 
The three main functions are define-class, new and get-slot.


define-class (class-name parent slot-values)
This class calls the function input-class-check to verify the correctness of the
arguments and to process the methods. It then proceed to verify if the parent,
if different from nil, exists, and if all the test were positive, calls the
function add-class-spec to add the class definition to the hash table.


new (class-name &rest slot-values)
This class instantiate a new object of type class-name. It proceeds to check
if the class is defined, if the slot-values are correct and process the method, 
this by calling the functions check-slot and slot-proc. It then creates the
instance list that contains all the attributes and method of the object.
Furthermore, this functions lets the user add new attributes or methods to the
instance (the class definition remains untouched), implementing a more
prototypal way of thinking an object oriented system.


get-slot (instance slot-name)
This function recovers from the instance the slot-value associated to the 
slot-name, be it an attribute or a method. It works by first checking in the
instance, with the function find-slot. If nothing is found, the functions check
in the class definition, again with the find-slot. If even this fails, the 
functions find-slot-p is called.


===


While this three functions explained above are the API for the user to control
the object oriented system, there are also some auxiliary functions that do all
the dirty works for the major three:


input-check-class (name parent slot-values)
This function check if the arguments are correct, by verifying that name and
parent are symbol and by calling the recursive function check-slot to check if
the attributes and the methods are correct.


check-slot (slot-values)
This function check if the first element of the input list is a symbol, and then
proceeds to recursively call itself with the list from the third element. 
Returns True when the list is correct, nil otherwise.


find-slot-p (parent slot-name)
This function recursively looks for the slot-name in the parent class, by 
calling the function find-slot on the parent. If the slot is not found and
there is another parent in the class hierarchy, looks recursively into the 
grandparent.


find-slot (list-arg slot-name)
This function looks for the slot-name in the list-arg. If found, returns a cons
composed like this (slot-name . slot-value), if not returns nil. The return is
done this way to let the user define an attribute with the values nil. In this
case, the function would return (slot-name .  nil), which is different from nil.
Thas is useful beacuse nil is the value returned if the slot isn't found.
Note: in theory it's possible for the user to define even the slot-name as nil:
		- (symbolp nil) = true
		- (null (cons nil nil) = false


slot-proc-values (slot-values)
This recursive functions scans the list slot-values and returns the same list
with the methods processed, by calling the function method-process.


method-process (method-name method-spec)
This function takes as arguments the method's name and the method' specifics, 
which are the method's arguments and the method's body. It then creates an
anonymous (lamba) function which represent the method' specifics plus a THIS
argument, and associates the labda in the current enviroment with the method's 
name. After this, the function calls eval (rewrite-method), wich is the returned 
value.


rewrite-method (method-spec)
This function rewrites the method' specifics by adding a THIS parameter to a
lambda that is returned. 

