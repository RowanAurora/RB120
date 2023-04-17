Calling methods with self

We use self to disambiguate from creating local variables. This is the main reason, and usuaully with accesor methods.
We can call other methods with self, but it is often not required and ruby style guide reccomends against using self when not required.

Other self things.

1. To disambiguate from creating or reassigning a local variable
2. In the definition of class methods
3. To refer to the class itself

Inside an instance method, self refers to the calling object. 
Inside a class definition but outside of instance methods, self referes to the class. This includes class methods.