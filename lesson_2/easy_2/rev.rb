class Transform
  def initialize(data_stuff)
    @data_stuff = data_stuff
  end

  def uppercase
    @data_stuff.upcase 
  end

  def self.lowercase(data_stuff)
   data_stuff.downcase
  end

end


my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')