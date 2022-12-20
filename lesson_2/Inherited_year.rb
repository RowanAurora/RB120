class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Truck < Vehicle
  attr_accessor :bed
  def initialize(year, bed)
    super(year)
    start_engine
    @bed = bed
  end

  def start_engine
    puts 'Ready to go!'
  end
end

class Car < Vehicle
end
truck1 = Truck.new(1994, 'Short')

puts truck1.year
puts truck1.bed