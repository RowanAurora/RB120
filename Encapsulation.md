Encapsulation
- Hiding pieces of functionality and making it unavailble to the rest of the code. A code capsule.
- Makes sure data cannot be manipulated without obvious intent
- Encapsulating code allow for abstraction, can think in terms of whole methods "do this" instead of base code and logic
- In ruby this is accomlished by creating objects and exposing interfaces( in the form of methods available to the class of object)
- this allows objects to be nouns and methods to be describe behaviour or verbs (draw a card, not `hand << cards[0]` 

Polymorphism
- The ability of different kinds of data to respond to the same type of interface (methods)
- Multiple differenct classes of objects that respond to the saem method (ie move for humans fish and cars)
-Allows using pre wirtten code for multiple purposes

Inheritance 
-Class inherits behaviour from parent class (superclass)
-Allows grouping common behaviours in a super class and having multiple sub classes use that behaviour
- Allows polymophism 


  super

  - super calls method earlier in the lookup path and invokes
  - good for extending the functionallity of a method in subclasses
  - when no specific arguments are passed to super, any arguments passed to the method containing super will be passed up the method lookup path.
  - if you pass arguments to super only those will be passed up
  - if you call with super() then no arguments will be passed


Modules
- Similar to inheritance but behaviour only, can not initialize new objects
- A "Mixin" 
  - Allows a class to have the behaviours described in the modules

Inheritance is a "is a" relationship, Mixin is a "has a" relationship

- One of the main benifit of mixin modules is to 'DRY' your code
 allows for unrelated classes to share behaviours 

Another use for modules is name spacing, 
That is, grouping similar classes together in a module
- to call these classes use Module::Class
ie kitty = Mammal::Cat.new

Another use is a a container for methods 
- looose methods can be added to a module and called direectly  ie 
  -value = Mammal.some_out_of_place_method(4)
  OR
  value = Mammal::some_out_of_place_method(4)


Objects
- ALMOST everything in ruby is an object. Its a simplified but handy way to look at it
- anything that has a value is an object
- Objects are created from classes.
  - Classes are like molds or factory that create objects of a type
  - objects are...objects produced by the class. 


   
Classes
- Ruby uses calsses to define the attributes (states) and behaviours (methods) of an object
- Classes are basic outlines of what an object is and can do

CLASSES ARE CamelCase!!!

Creating an object (re: instance) of a class is called instantiation.
- the class method "new" instnatiates an object
  - some classes have syntax that can do this. LIke arrays variable = [] instantiates a array object. or variable = "dsagasg" instatiates a string object.

Modules
- Uses to create polymorphism and share behaviours
- syntax to create it `module ModuleName; end`
- syntax to use it is `include ModuleName`


Classes typically focus on 2 thigns 
1. States
  -States refere to the data assosiated with a individual object (tracked by instance variables)
2. Behaviours
  -What objects are capable of doing. expressed through methods.

Two objects of the same class will share the same set of behaviours; but they will have different states. 
Instance variaables ( @variable )
  -keep track of states
Instance methods (method)
  - expose behaviour

the "new" class method eventually calls on the initialize instance method.
Initialize is a "constructor" 
  - it is triggered when a new ojbect is instantiated

While not syntactically required - it is good form to list your instance variables in your initialize method. This means you can see at a glance what instance variables and thus states on object can have in a class

Accessor methods 
SEAK CLARITY HERE

Created accessor methods

Getter method 
Getter methods can be written as below or we can use attr_reader

```ruby 
def get_variable 
  @instancevariable
end
```

Setter methods 
setter methods are sused to modify the value of an instance variable
They can be written, as below, or we can use attr_writer

- This comes with syntactical sugar of allowing `Variable.setter_method = new_thing`
- This allows for closer approximation of natural assignment

Setter methods always return the value passed in as argument, regardless of content of the method.

```ruby
def set_variable=(variable)
  @variable = variable 
end
```

As convention setter and getter methods that are created manually share the name of the instance variable they target.

Attr_accessor automatically creates encapsulated getter and setter methods 
- `attr_accessor :variable, :other_variable` is the syntax
- same for attr_reader and attr_writer

Self

```ruby
name = n
height = h
weight = w
```

above is interpreted as creating local variables
To avoid this, we can call on self to differntiate

```ruby 
def change_info(n, h, w)
  self.name = n
  self.height = h
  self.weight = w
end
```
- this ensures we are calling a setter method not instantiateing a local variable
- Ruby style guide insists on not using self where it is not required.

inside a class self referes usually to the calling object (classes are also an object)

in method definition in a class defines a class method

inside a class but not inside a method refers to the class itselfs

Class Method

- class methods pertain to the class itself and do not require an instantiated object to call.
- `def self.method; end`
- If a method does not interact with or need states it can often be a class method.
- Class.method is the way to call

- class methods cannot access insttance variables
Class Variables

- Class variables contain values pertaining to the class itself. THis can be number of objects instantiated or a piece of data that all objects of a class share (that cant be described by a constant for whatever reason)
- `@@variable`
- Must pertain to class and no individual object

Constants 
- unchanging information
- `CONSTANT = 'info'
- Scoped to a class, but can be called in other places with Class::CONSTANT

To_s Method
  - Often overridden in specific class to help formatting
  - Is meant to convert data to human readable infomation, so with custom classes some
  new information is often required to make that happen.

  - to_s is automattically called in a number of cases such as puts or in string interpolation. Overriding the default to_s can ensure proper functionality


Access control 

Access modifiers (Private, protected, public)

Anything below an input access modifier is under that label unless a new one is used

Public

A public method is available to "anyone" who knows either the class or object name. 
They are available to rest of the program and are a classes public interface.
  - How other classes and objects interact with your class

Private

A private method is one that is not available outside of the class. Used when a method is only called inside of a class and not available to the rest of the program

Protected

In between public and private. Can't be invoked outside the class but can allow access between class instances(objects)


In the case of comparing two objects of the same class for instance, we can use protected to compare a state of the objects and call in the public access part.

Method Overriding

All classes you create inherit from the Object class, which contains a bunch of important methods that you shouldint overwrite

-Obejct#send for example is important.
   - send is a away of calling a method by passing a symbol or string to send.

Collaborator objects:

Objects that are stored in states (re: instance variables) of other objects are called collabortor objects. For example, In a Deck object, we may contain a bunch of card objects that are collabrators. 

Collaborator objects serve as a connection between classes and exposes the relationship betwee them.

Similar to modules, collabortor relationship (Association) is a has-a relationship but with objects not behaviors. Library HAS books (collabortor object), or a libary has sections, with has books.
