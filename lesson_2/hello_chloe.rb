class Cat
  attr_accessor :name
  COLOR = 'purple'

  @@total_cats = 0

  def initialize(name)
    @name = name
    @@total_cats +=1
  end

  def rename(name)
    self.name = name
  end

  def indentify
    self
  end

  def personal_greeting
    puts "Hello! My name is #{name}"
  end

  def self.generic_greeting
    puts "Hello! I'm a cat"
  end

  def self.total
    puts @@total_cats
  end

  def greet
    puts "Hello! My name is #{name} and I'm a #{COLOR} cat."
  end

  def to_s 
    "I'm #{name}!"
  end
end
cat = Cat.new("Spritty")
kitty = Cat.new('Sophie')
puts kitty