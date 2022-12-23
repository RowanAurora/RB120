class Banner
  def initialize(message, size)
    if message.size > size 
      @message = message[0, size - 2]
      @size = size
    else
      @message = message
      @size = size 
    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-" + ("-" * @size) + "-+"
  end

  def empty_line
    "| " + (" " * @size) + " |"
  end

  def message_line
    if @size.even? 
    "|#{" " * ((@size - @message.size) / 2 + 1) } #{@message}#{" " * ((@size - @message.size) / 2 + 1 ) }|"
    else
      "|#{" " * ((@size - @message.size) / 2 ) } #{@message}#{" " * ((@size - @message.size) / 2 + 1) }|"
    end
  end
end

wow = Banner.new("Wow Wow Wow", 26) 
puts wow
