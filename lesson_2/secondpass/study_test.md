## Classes and objects
Classes
  - Classes are the structure that governs what behaviors objects have and what states they can posses. Metaphorically, they are the mold that objects are cast from. Custom classes are defined as below

```ruby
class Person
  #class contents
end
```
Objects are instances of a class. They have behaviors (methods) and states (instance variables). All objects of a class share a set of behaviors, but have their own states. To clarify, that means that the instance variables @value for one object might be assigned to the integer 3, and another objects @value instance variable could have a value of 6. Objects are instantiated as below 
```ruby
kitten = Cat.new(# any required arguments)
``` 

## Use attr_* to create setter and getter methods

We can use a nice bit of ruby to create getter and/or setter methods. 
We can use `attr_reader` to automatically create a getter method for each instance variable we put as an argument, passed as a symbol.

attr_reader creates a getter that is equivalent to the `name` method in the example below:

```ruby
class Cat

  def initialize(name)
    @name = name
  end

  def name #this method is equivilent to the getter creater when we use attr reader
    @name
  end
end
```

<!-- attr_writer is equivalent to the `name=` method in the example below -->

```ruby
class Cat

  def initialize(name)
    @name = name
  end

  def name=(name) #this method is equivilent to the getter creater when we use attr_writer
    @name = name
  end
end

```

```ruby
class Person
  attr_reader :name, :age
  #class contents
end
```
We can create setter methods much the same with with `attr_writer`. 
To create both getter AND setter methods we can use `attr_accessor`

## How to call setters and getters

Getter and setter method callings both have particular bits of syntax. For getter methods, outside of a class we can call the getter method name on the object, as below
```ruby
kitten.name
```
Inside of a class, we can to be sure we are calling a getter method and not initializing a new local variable. Below are two example of setter methods, the first one accidentally initializing a local variable, and the second using self to call the getter method.

The wrong way below :
```ruby 
def name=(other_name)
  name = other_name
end
```
and the correct way:

```ruby 
def name=(other_name)
  self.name = other_name
end
```

Setter methods allow for some ruby syntactical sugar. When we define a setter method 
```ruby
def name=(name)
  @name = name
end
```
It suggests we should call it as `setter=(other)` and this is not incorrect, but ruby allows us to call it as `setter = other` for easier readability and usability.

## Instance variables, class variables, and constants, including the scope of each type and how inheritance can affect that scope

  ### Instance variables
  Instance variables are a particular form of variables that represent states for objects. Defined inside a class definition with an `@` , `@instance_variable ` is an example of how that looks. 

  They are scoped at the object level, which means they are available anywhere in a class definition for a particular instance of that class, but not share between instances.

  ### Class variables
  Class variables are variables that pertain to the class as a whole. Defined with 2 `@` symbols, they look like @@class_variable. 
  
  They are scoped in an interesting way in that they are available anywhere in the class they are defined in, and a class family shares class variables, but if a class variable isnt initialized in a class in the inheritance hierarchy, it isn't available there. 

  ### Constants

  Constants are lexically scoped. They are available in the structure they were defined in, and substructures in that structure. 

  When looking for a Constant that is called, Ruby will search first in the structure its defined, then each outer structure , and then the inheritance hierarchy until it finds the constant or produces in an error. 

  Constants are meant to be unchanging facts in your code. 
  They are defined with a capital letter, but ruby style suggests using all capital letters. `CONSTANT = value`

## Instance methods vs. class methods

  Instance methods are 'behaviors' for objects and pertain to individual objects. Public instance methods are called by objects of that class, and instance methods in general are also used within the class. 
  Below is an example of an instance method definition. It would be called `kitten.speak(thing)`
```ruby
  class Cat
    def speak(thing)
      # method stuff
    end
  end
```

  Class methods are methods that pertain to the class itself, and are called on the class. They don't pertain to a particular object of that class. They are defined by prepending with self. To call, we call on the class itself ie `Cat.count`. Below is an example of a class method definition.

  ```ruby
  class Cat
    def count
      # method stuff
    end
  end
  ```

## Method Access Control

  Method access control is a way of protecting data and methods in class. There are 3 levels of method access that are defined by the methods : public, private, and protected.

  Public methods are the interface for the class. They are available to anyone who knows the name and has an object of that class. This is the standard access level for methods in a custom class, and can also be manually set with the `public` method.

  Private methods are a way of protecting data and preventing accidentally manipulation. They can only be called from inside the class, and are used for internal mechanisms in a class and are often called by public methods. This is a method of encapsulation and hiding away functionality of the class. 
  They are set by defining the methods under the private method

  Protected methods are similar to private methods, but they can interact with other objects of the same class. Often used for comparing objects of a class with others. You can set the access level to protected by defining the methods underneath a call to the protected method.

  Below is an example of using method access controls.

  ```ruby
  class Cat

  def zoomies
    #this is a public method
    energy
    three_am
  end

  private

  def energy
    #this is a private method
  end

  def three_am
    # this is a private method too
  end

  protected

  def same_hat?(other)
    self.hat == other.hat
  end

  public

  def speak
   puts "meow"
    #this is a public method!
  end
end
```

## Referencing and setting instance variables vs. using getters and setters

Inside of a class instance variabels can be referenced or set using getters and setters or manually. 
  Using getters and setters can ensure data protection and avoid accidental manipulation. By using getters and setters under access protection, we can avoid exposing or accidentally overiding instance variables. If we need to modify the data before it is used or printed, we can by calling a custom getter. 
  This can also result in more neat and ordered looking code, avoiding all the `@` symbols from the instance variables. 

  We can also reference or reassign instance variables manually by using the name of the instance variable ie `@name`

## Class inheritance, encapsulation, and polymorphism

### Class Inheritance
  Class inheritance is a method of defining a relationships between classes on an is-a basis. A child of a parent class inherits its behaviors and attributes
  This can be continued in a chain. It is a good way to create polymorphism and DRY up code by congregating common behavior in the super class (parent class). 
  Classes can only directly inherit from a single class at a time but that includes the parents of the parent class.

  ```ruby
  class Pet
    # class stuff
    def speak
      puts "yes"
    end
  end

  class Cat < Pet
  end

  kitty = Cat.new
  kitty.speak # => yes
```

### Encapsulation
  Encapsulation is a concept about containing code and hiding functionality. It can help coders think with a higher level of abstraction by hiding the inner workings of code. It can also be used to prevent manipulation of data that we don't want to be changed, and prevent accidental manipulation. 

  Private methods are a common way of creating this, as well as methods such as `puts` that contain multiple operations in a single method call. In the case of `puts`, it calls `to_s` and prints on a new line. 

  This creates easier to read an understand code, where you can see the main flow of logic and can look closer at parts separate from the rest of the code base.

  In the below functionality 
  ```ruby
class CustomClass
  # class stuff
  def method_exposing_stuff
    secret_stuff
  end

  private

  def secret_stuff
   puts thing_one + thing_two
  end

  def thing_one
    "Hello, "
  end

  def thing_two
    "is it me you're looking for!"
  end
end
```
#### Polymorphism

Polymorphism is the ability of multiple data types to respond to the same input. This is often accomplished through inheritance, where common behaviors are grouped in parent classes. It can also be accomplished through duck-typing where we can add methods to desperate classes to make their objects respond to the same input. 
Ie it if it talks like a duck, it might as well be a duck. 
Methods like to_s that can be used on multiple different object types show this concept well.
Below is an example of polymorphism using the method custom method polymethod
 ```ruby
  class CustomClass
    # class stuff
    def polymethod
      puts "yes"
    end
  end

  class SubClass < CustomClass
  end

  class Unrelated
    def polymethod
      puts "maybe"
    end
  end

  var = Subclass.new
  car.polymethod # => yes
  var2 = CustomClass.new
  var2.polymethod # => yes
  var3 = Unrelated.new
  var3.polymethod # => maybe
```
## Modules
Modules are a structure that is similar to classes, but can not instantiate objects. 
There are a few different uses for modules, the main being namespacing, and mixin modules.

Mixin Modules are  a way of grouping methods and sharing them with classes by including the module. This can be good for grouping common behaviors from unrelated classes, or grouping a set of related methods that belong in an extensive class, such as putting all the methods responsible for outputting things to the screen in a Displayable modules. 

Namespacing is a way of grouping related classes, to contain them in one place, and clarify where they are and what they are for. classes are defined within a module, and reached though the module it `Module::CustomClass` and `Module::OtherClass`.


## Method lookup path
  The method lookup path is the trail that ruby follows to find a method when called. It starts in the class of the object that a method is called with, and goes up the inheritance hierarchy of classes and modules. Calling ancestors on a class will detail the path.

  Ruby looks in the current class, then the included modules from the last included to the first, and then up the inheritance chain, repeating the process.

  ```ruby 
  class CustomClass
    # class stuff
    def method_to_be_inherited
      puts "yes"
    end
  end

  class SubClass < CustomClass
  end

  SubClass.ancestors # =>  => [SubClass, CustomClass, Object, Kernel, BasicObject] 
  ```

## self

Self in custom classes has a few meanings, namely, the calling object or the class itself.

Inside instance methods, self refers to the calling object.
Outside of instance method definitions but inside the class definition, self refers to the class itself.
This is true outside of any method, as well as inside of class methods.

Self - As the calling object

```ruby
class Cat
  def yell_cat
    puts self.class.upcase
  end
  protected

  def ==(other)
    self.name = other.name
  end
end
```

and self as the class 

```ruby
class Cat

  def self.yelling
    puts self
    puts "BINGBONG"
  end

  puts self
end

Cat.yelling

# => CustomClass
# => BINGBONG
# => CustomClass
```


## Calling methods with self
We call methods with self to differentiate from creating a local variable. Ruby style recommends avoiding self where not required

Below, we call the getter method name using self

```ruby
class Pet
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def ==(other)
    self.name == other.name
  end
end

doggy = Pet.new("Jinx")
kitty = Pet.new("Jinx")
kitty == doggy # => true

```


## More about self


## Reading OO code


## Fake operators and equality
Ruby has a number of fake operators, that is methods that at first appear to be operators. The relevant example here is equality and comparison operators. 

With custom class objects, if we wish to compare them we need to define the comparison method, or else ruby will go up the method lookup chain and seeing if the objects are in-fact the same object.

If we define the == method, we can choose what is compared about the object, or if multiple states are compared. =! comes as a freebie when we define == as well. 

Other 'Fake operators' that can be redefined in the class are >, <, <=> among others.

In this example, we are using the size state as the basis for comparing two objects relying on the basic object ==

```ruby
class CustomClass
  def initialize(size, price)
    @size = size
    @price = price
  protected

  def other_method(other)
    self.size == other.size
  end
end
```

## Working with collaborator objects

Collaborator objects are objects that are held as a state in another classes object. They define a relationship between classes and how they interact. Generally, we are talking about custom objects but a string, array, hash ..etc is technically a collaborator object when used as such. 

In the example below, the value assigned to `@object` is a collaborator, as is the object assigned to `@obj2`

```ruby
class Person
  def initialize(pets)
    @organs = Organs.new
    @pets = pets
  end
end

class Pets
end

kitten = Pets.new
jack = Person.new(kitten)
```
