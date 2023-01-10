module Run
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

dan = Run.new('dan')