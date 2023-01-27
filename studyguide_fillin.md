Study guide fill in  
Self
calling getter and setter methods (particularly indexed assignement and retrieval)
Name spacing and module specifics

Classes and objects

At the base, class and objects are like molds(classes) and casts(objects).
An object of a class has unique states expressed as instance variables.
Objects of a class have behaviours expressed as public instance methods. 



Use attr_* to create setter and getter methods
attr_reader, attr_writer and attr_accessor are short forms of creating getter and setter methods for specific instance variables. To create the methods, add the reservered words and use a symbol of the variable ie 
attr_reader :thing



How to call setters and getters
setter methods allow for some syntactical sugar. Defined by 
```ruby 
def variable=(other)
  variable = other
end
```
can be called as variable = other.
indexed assignemnt aswell is defined as 

*** LOOK THIS UP***

To call a getter method in the class, simply use its name or self.method.
outside use object.method. INside the class @variable can be replaced with the getter method variable.

Instance variables, class variables, and constants, including the scope of each type and how inheritance can affect that scope

Instance variables are variables that *are* the state of an object. Usually initialized with the instantiation of a new object, in the creator methods.
defined by the @ symbol. (@variable) they are unique to each object of the class. They are inscope across the class. 
Class variables are variables for the class itself. Each object shares the same class variables, used to track or contain values that are pertinant to the whole class.
 defined with @@ (@@variable).
Class variables are scope not only for the class, but also across the inheritance family. if a subclass reassigns a class variable, a different child of the superclass would reflect that change aswell. 


Instance methods vs. class methods
Instance methods are the behaviour of the class. The public methods are the interface that object use to interact. Private and protect methods are used interannly in the class. Public instance methods can be called by objects of the class (obj.method(arg))
THe others can only be accessed internally.
Define as other procedural methods are.

Class methods are methods that pertain to the class itself. They are call on the class ie
Class.method or Class::method. 

Method Access Control
Method access control is used to encapsulate parts of the program and prevent data from accidentally or carelessly being manipulated. 
Method access control is covered by the public, private and protected methods.
Public methods can be called by anyone with access to an object of that class.
Protected methods are similar to private methods but can be used with other objects of the same class, Such as in comparison.

Private methods can only be called inside the class and not on other object. This prevents access and accidental manipulation

Referencing and setting instance variables vs. using getters and setters


Class inheritance, encapsulation, and polymorphism
Class inheritance is the process that classes..inherit behaviours from(aswell as class variables). Children of a classes child also inherit the superclases behaviours(methods). The classes can be overridden or modified.

Encpsulation is the concept of hiding away functionality. Private methods, or methods that call other methods to form more complex behaviours exhibit this. When we call methods like private or even p or puts, we demonstrate encapsulation. P calls inspect on an object and prints, puts calls to_s and prints on newline. a lot of the functioanlity is encapsulated and hidden away.

Polymorphism is the ability of multiple types of data to respond to the same command. Methods like each, or puts demonstrate this pretty well, as you can all these on a wide variety of objects from diffrent classes. THis can be achived through inheritance, which is common or through duck-typing or by using the same mixin modules..  

Modules
Modules are a similar data strucutre to classes, but they dont instantiate objects. 
Modules have a few different uses:
Mixin: Mixin modules are a way to gather common behaviours that can be shared between classes. It is a good way to group similar methods aswell, such as methods responsable for displaying things to the screen. 

Name spacing: Modules can be used to group similar classes together aswell. This can help track where things are comming from. calling ModuleName::Class can clear up where methods or objects are located and what behaviours they exhibit. ***LOOK MORE OF THIS UP***


Method lookup path
  The method lookup path is the trail that ruby follows when we call on a method. It first checks from class its called from, and if not available will try each subsequent parent untill it finds a method under that name, and if not returns an error. 

self
  Self is a way of representing a calling object inside a class. In method definition it defines a class method `def self.method; end`
  it can represent that class its in or more often the specific object from inside the class definition. 

Calling methods with self
 To prevent creating a local variable and ensure the getter or setter method is used, we use self ( self.name = name)
 This is importnatn with setter methods and can be used with getter methods but is not required. This can be used with any instance method to ensure you are calling it on the specific object.

The ruby style guide say to avoid using self where not required.

More about self

1. use self when calling setter methods from within the class. 
2. use self for class method definitions.

From within the calss when an instance method uses self, it references the calling object.

calling self.method inside the class is the same as calling object.method outside of the class.


Reading OO code


Fake operators and equality
Ruby has plenty of fake operators that are actually methods. Comparisons are a major one, with >, <, ==, ===, +. - being methods themselves that pretend they are operators. This adds a level of flexibilty to custom classes as we can control how they work for each type of object.

Working with collaborator objects
Collaborator objects are objects in the state of other objects. If we have for example a person class, they might have a pet object as the value of a state. the pet object is the collaborator object. technically, strings, arrays, hashes are also collaborator objects but generally the concept focusues on custom class objects. 
They can define the relationshoip between different classes.

[] and []=

For use with collections

```ruby
def [](idx)
  members[idx]
end

def []=(idx, obj)
  members[idx] = obj
end
```

Ruby automatically allows for the syntactical sugar of array[idx] = object and array[idx]
which is easier to read. 