FLOORS = [1, 2, 3]

def change_floor(ele)
  answer = nil
  puts "Choose your floor"
  loop do
    answer = gets.chomp.to_i
    break if FLOORS.include?(answer)
    puts "#{FLOORS} are the options"
  end
  ele.floor_change(answer)
end
    

class Elevator 
  attr_accessor :floor
  def initialize 
    @floor = 0
    @characters = []
  end

  def floor_change(floor)
    @floor = floor
  end

  def char_enter(characters)
    @characters << characters
  end

  def char_exit(characters)
    @characters.delete(characters)
  end
end

class Character
  attr_accessor :location
  attr_reader :name
  def initialize
    @location = "elevator_area"
    @name = "Boblin the goblin"
  end
end

character = Character.new
front_elevator = Elevator.new

if character.location == "elevator_area"
  front_elevator.char_enter(character)
  change_floor(front_elevator)
  puts "#{character.name} changed floor to #{front_elevator.floor}"
end


