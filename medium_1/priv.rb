class Machine

  def start
   flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def on_or_off
    switch
  end

  private 

  attr_writer :switch
  
  def switch 
    @switch
  end

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

bing = Machine.new 

p bing.start
p bing.stop
p bing.on_or_off