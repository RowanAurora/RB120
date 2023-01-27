module Drivable
  def drive
  end
end

class Car
  extend Drivable
end

bobs_car = Car.new
Car.drive

