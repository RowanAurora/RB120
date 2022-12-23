class House
  attr_reader :price
  include Comparable
  def initialize(price)
    @price = price
  end

  def <=>(other)
    price <=> other.price
  end

  protected

  def compare(house1, house2)
    house1 > house2
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1.price < home2.price
puts "Home 2 is more expensive" if home2 > home1