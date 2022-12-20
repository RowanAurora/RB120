class Pets 
  
  def run
    'running!'
  end

  def jump
    'jumping!'
  end

  def speak
    'bark!'
  end
end

class Cat < Pets 
  def speak
    "MEOW"
  end
end

class Dog < Pets

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim 
    "icantswim"
  end
end

pete = Pets.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

pete.run                # => "running!"
pete.speak              # => NoMethodError

kitty.run               # => "running!"
kitty.speak             # => "meow!"
#kitty.fetch             # => NoMethodError

dave.speak              # => "bark!"

bud.run                 # => "running!"
bud.swim 


# The method look up path is the route ruby checks up the ancestry tree 
# in order to determine what method is being used 