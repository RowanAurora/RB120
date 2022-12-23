class Pet
  attr_reader :type, :name
  def initialize(type, name)
    @type = type
    @name = name
    Shelter.hold(self)
  end

  def to_s
    "a #{type} named #{name}"
  end
end


class Owner 
  attr_reader :name, :pets 

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    @pets << pet
  end

  def number_of_pets
    @pets.size
  end

  def print_pets
    puts pets
  end
end

class Shelter
  attr_reader :owner
  @@adoptables = []

  def initialize
    @owners = {}
  end

  def self.hold(pet)
    @@adoptables << pet
  end

  def self.for_grabs
    puts
    puts "The shelter has the following animals ready for adoption:"
    puts @@adoptables
  end

  def adopt(owner, pet)
    if @owners.include?(owner)
      owner.add_pet(pet)
      @owners[owner] << pet
      @@adoptables.delete(pet)
    else
      owner.add_pet(pet)
      @owners[owner] = [pet]
      @@adoptables.delete(pet)
    end
  end
  
  def print_adoptions
    @owners.each_pair do |key, value|
      puts "#{key.name} has adopted the following pets:"
      puts value
      puts
    end
  end
end






butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
asta         = Pet.new("dog", 'Asta')
laddie       = Pet.new("dog", 'Laddie')
fluffy       = Pet.new("cat", 'Fluffy')
kat          = Pet.new("cat", 'Kat')
ben          = Pet.new("cat", 'Ben')
chatterbox   = Pet.new("parakeet", 'Chatterbox')
bluebell     = Pet.new("parakeet", 'Bluebell')





phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
Shelter.for_grabs