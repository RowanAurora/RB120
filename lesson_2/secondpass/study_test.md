## Classes and objects
Classes
  - Classes are the structure that governs what behaviours objects have and what states they can posses. Metaphorically, they are the mold that objects are cast from. Custom classes are defined as below

```ruby
class CustomClass
  #class contents
end
```
Objects are instances of a class. They have behaviours (methods) and states (instance variables). All objects of a class share a set of behaviours, but have their own states. To clarify, that means that the instance variables @value for one object might be assigned to the integer 3, and another objects @value instance variable coould have a value of 6. Objects are instantialed as below 
```ruby
var = CustomClass.new(# any required arguments)
``` 

## Use attr_* to create setter and getter methods

We can use a nice bit of ruby to create getter and/or setter methods. 
We can use `attr_reader` to automatically create a getter method for each instance variable we put as an argument, passed as a symbol.
```ruby
class CustomClass
  attr_reader :var, :other_var
  #class contents
end
```
We can create setter methods much the same with with `attr_writer`. 
To create both getter AND setter methods we can use `attr_accessor`

## How to call setters and getters

Getter and setter method callings both have particular bits of syntax. For getter methods, outside of a class we can call simple
```ruby
object.getter_method
```
Inside of a class, we can to be sure we are calling a getter method and not initializing a new local variable. The wrong way below :
```ruby 
def instance_method=(other_thing)
  var = other_thing
end
```
and the correct way:
```ruby 
def instance_method=(other_thing)
  self.var = other_thing
end
```

Setter methods allow for some ruby syntactical sugar. When we define a setter method 
```ruby
def setter=(other)
  @var = other
end
```
It suggests we should call it as `setter=(other)` and this is not incorrect, but ruby allows us to call it as `setter = other` for easier readability and useability.

## Instance variables, class variables, and constants, including the scope of each type and how inheritance can affect that scope

  ### Instance variables
  Instance variables are a particular form of variables that represent states for objects. Defined inside a class defenition with an `@` , `@instance_variable ` is an example of how that looks. 

  They are scoped at the object level, which means they are available anywhere in a class definition for a particular instance of that class, but not share between instances.

  ### Class variables
  Class variables are variables that pertain to the class as a whole. Defined with 2 `@` symbols, they look like @@class_variable. 
  
  They are scoped in an interesting way in that they are available anywhere in the class they are defined in, and a class family shares class variables, but if a class variable isnt initialized in a class in the inheritance hierachy, it isnt available there. 

  ### Constants

  Constants are lexically scoped. They are available in the structure they were defined in, and substructures in that structure. 

  When looking for a Constant that is called, Ruby will search first in the strcuture its defined, then each outer structure , and then the inheritance hierachy untill it finds the constant or produces in an error. 

  Constants are meant to be unchanging facts in your code. 
  They are defined with a capital letter, but ruby style suggests using all capital letters. `CONSTANT = value`

## Instance methods vs. class methods

  Instance methods are 'behaviours' for objects and pertain to individual objects. Public instance methods are called by objects of that class, and instance methods in general are also used within the class. 
  Below is an example of an instance method definition. It would be called `custom_class_object.instance_method(thing`)
```ruby
  class CustomClass
    def instance_method(thing)
      # method stuff
    end
  end
```

  Class methods are methods that pertain to the class itself, and are called on the class. They don't pertain to a particular object of that class. They are defined by prepending with self. To call, we call on the class itself. `CustomClass.class_method(thing)` Below is an exampe of a class method definition.

  ```ruby
  class CustomClass
    def self.class_method(thing)
      # method stuff
    end
  end
  ```

## Method Access Control

  Method access control is a way of protecting data and methods in class. There are 3 levels of method access that are defined by the methods : public, private, and protected.

  Public methods are the interface for the class. They are avaialble to anyone who knows the name and has an object of that class. This is the standard access level for methods in a custom class, and can also be manually set with the `public` method.

  Private methods are a way of protecting data and preventing accidentaly manipulation. They can only be called from inside the class, and are used for interal mechanisms in a class and are often called by public methods. This is a method of encapsulation and hiding away functioanlity of the class. 
  They are set by defining the methods under the private method

  Protected methods are similar to private methods, but they can interact with other objects of the same class. Often used for comparing objects of a class with others. You can set the access level to protected by defining the methods underneath a call to the protected method.

  Below is an example of using method access controls.

  ```ruby
  class CustomClass

  def method_one
    #this is a public method
  end

  private

  def method_two
    #this is a private method
  end

  def method_three
    # this is a private method too
  end

  protected

  def method_four
    #this is a protected method
  end

  public

  def method_five
    #this is a public method!
  end
end
```

## Referencing and setting instance variables vs. using getters and setters

Inside of a class instance variabels can be referenced or set using getters and setters or manually. 
  Using getters and setters can ensure data protection and avoid accidental manipulation. By using getters and setters under acess protection, we can avoid exposing or accidentally overiding instance variables. If we need to modify the data before it is used or printed, we can by calling a custom getter. 
  This can also result in more neat and ordered looking code, avoiding all the `@` symbols from the instance variables. 

  We can also reference or reassign instance variables manually by using the name of the instance variable ie `@instance_variable`

## Class inheritance, encapsulation, and polymorphism

### Class Inheritance
  Class inheritance is a method of defining a relationships between classes on an is-a basis. A child of a parent class inherits its behaviours and attributes
  This can be continued in a chain. It is a good way to create polymorphism and DRY up code by congregating common behaviour in the super class (parent class). 
  Classes can only directly inherit from a single class at a time but that includes the parents of the parent class.

  ```ruby
  class CustomClass
    # class stuff
    def method_to_be_inherited
      puts "yes"
    end
  end

  class SubClass < CustomClass
  end

  var = Subclass.new
  car.method_to_be_inhertited # => yes
```

### Encapsulation
  Encapsulation is a concept about containing code and hiding functionality. It can help coders think with a higher level of abstaction by hiding hte inner workings of code. It can also be used to prevent manipulation of data that we dont want to be changed, and prevent accidental manipulation. 

  Private methods are a common way of creating this, aswell as methods such as `puts` that contain multiple operations in a single method call. In the case of `puts`, it calls `to_s` and prints on a new line. 

  This creates easier to read an understand code, where you can see the main flow of logic and can look closer at parts seperate from the rest of the code base.

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

Polymorphism is the ablility of multiple data types to respond to the same input. This is often accomplished through inheritence, where common behaviours are grouped in parent classes. It can also be accmomplished through duck-typing where we can add methods to disperate classes to make thier objects respond to the same input. 
Ie it if it talks like a duck, it might as well be a duck. 
Methods like to_s that can be used on multiple differnt object types show this concept well.
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

Mixin Modules are  a way of grouping methods and sharing them with classes by including the module. This can be good for grouping common behaviours from unrelated classes, or grouping a set of related methods that belong in an enxtensive class, such as putting all the methods responsilbe for outputting things to the screen in a Displayable modules. 

Namespacing is a way of grouping related classes, to contain them in one place, and clarify where they are and what they are for. classes are defined within a module, and reached though the module it `Module::CustomClass` and `Module::OtherClass`.


## Method lookup path
  The method lookup path is the trail that ruby follows to find a method when called. It starts in the class of the object that a method is called with, and goes up the inheritence hierachy of classes and modules. Calling ancestors on a class will detail the path.
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

Inside instance methods, self referes to the calling object.
Outside of instance method definitions but inside the class definition, self refers to the class itself.

Self - As the calling object

```ruby
class CustomClass
  def insta_method
    puts self.capitalize
  end
  protected

  def other_method(other)
    self.name = other.name
  end
end
```

and self as the class 

```ruby
class CustomClass

  def self.insta_method
    puts "BINGBONG"
  end

  puts self
end

CustomClass.insta_method

# => BINGBONG
# => CustomClass
```


## Calling methods with self
We call methods with self to differentiate from creating a local variable. Ruby style reccomends avoiding self where not required

```ruby
class CustomClass
  def insta_method
    puts self.capitalize
  end
  protected

  def other_method(other)
    self.name = other.name
  end
end
```


## More about self


## Reading OO code


## Fake operators and equality
Ruby has a number of fake operators, that is methods that at first appear to be operators. The relevent example here is equality and comparison operators. 

With custom class objects, if we wish to compare them we need to define the comparison method, or else ruby will go up the method lookup chain and seeing if the objects are infact the same object.

If we define the == method, we can choose what is compared about the object, or if multiple states are compared. =! comes as a freebie when we define == aswell. 

Other 'Fake operators' that can be redefined in the class are >, <, <=> among others.

In this example, we are using the size state as the basis for comparing two objects relying on the basicobject ==

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
class CustomClass
  def initialize(other_collab)
    @object = Collaborator.new
    @obj2 = other_collab
  end
end

class OtherClass
end

var1 = OtherClass.new
example = CustomClass.new(var1)
```
