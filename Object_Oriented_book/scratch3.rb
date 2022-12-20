
class Vehicle
  attr_accessor :color, :speed
  attr_reader :year, :model

  @@vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@vehicles += 1
  end

  def self.fleet
    puts "You've got #{@@vehicles} vehicle(s)."
  end

  def hit_the_gas(amount)
    @speed += amount
  end

  def break(amount)
    @speed -= amount
  end

  def off
    @speed = 0
  end

  def speedometer
    puts "Going #{speed}"
  end

  def fresh_paint(paint)
    @color = paint
    puts "Sick new #{color} paint job dude"
  end

  def self.gas_mileage(km, litres)
    puts "#{km / litres}km per litre."
  end

  def to_s
     color + " " + year + ' ' + model
  end

  def age
    puts "vehicle is #{calc_age} years old"
  end
  private
  def calc_age
    t = Time.now.year
    t - @year.to_i 
  end
end

module Haulable
  def can_haul?(weight)
    weight <= 4000
  end
end

class MyCar < Vehicle
DOORS = 4
end


class MyTruck < Vehicle
DOORS = 2
include Haulable
end

# putter = MyCar.new('1993', "Red", "Ford Pinto")
# puts putter.year
# putter.fresh_paint('Red and Black')
# MyCar.gas_mileage(400, 37)
# puts putter

# hauler = MyTruck.new('2004', 'chartreuse', 'Isuzi')
# p hauler.can_haul?(3000)
# Vehicle.fleet

# hauler.age

class Student
  attr_reader :name
  attr_writer :grade
  def initialize(name, grade)
    @name = name
    @grade = grade
  end
  
  def better_grade_than?(other_student)
    self.grades > other_student.grades
  end
  protected
  def grades 
    @grade
  end

end

carl = Student.new('Carl', 92)
emily = Student.new('Emily', 95)
p emily.better_grade_than?(carl)
carl.grades