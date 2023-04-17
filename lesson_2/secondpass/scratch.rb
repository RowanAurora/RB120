
class VendingMachine
  attr_accessor :inventory
  def initialize
    @coke = Stock.new("Coke")
    @diet_coke = Stock.new("Diet Coke")
    @sprite = Stock.new("Sprite")
    @inventory = [@coke, @diet_coke, @sprite]
    @cashonhand = 100
  end

  def purchase
    choice = nil
    payment = nil

    puts "Input money"
    payment = gets.chomp.to_i

    loop do
      puts "Select your drink, 4 to cancle"
      inventory
      choice = gets.chomp.to_i
      break if [1, 2, 3, 4].include?(choice)
      puts "Select your pop by pressing button"
    end

    process(choice, payment)
  end

  def process(item, cash)
    begin
    item = select_item(item)
    if item.amount == 0
      puts "Out of stock"
    elsif item.price > cash
      puts "Insuffient money"
      puts "Change: $#{cash}"
    elsif item.price <= cash && item.amount != 0
      item.amount -= 1
      change = cash - item.price
      puts "Dispensing..."
      puts "#{item.name} and $#{change}"
      @cashonhand += item.price
    end
    rescue 
      puts "Order Cancelled"
      puts "Change: $#{cash}"
    end
  end

  def select_item(item)
    case item
      when 1 then @coke
      when 2 then @diet_coke
      when 3 then @sprite
      when 4 then nil
      else 
        puts "Incorrect selection"
    end
  end

  def inventory
    choice = 1
    puts " ------------ "
    @inventory.each do |drink| 
      puts "#{drink}, Button: #{choice}"
      choice += 1
    end
    puts " ----------- "
  end
end


class Stock
  attr_accessor :price, :amount
  attr_reader :name
  PRICE = 1.00

  def initialize(name, price=PRICE)
    @name = name
    @price = price
    @amount = 10
  end

  def to_s 
    "#{name}: $#{price}"
  end
end

vend = VendingMachine.new 
vend.inventory
vend.purchase

