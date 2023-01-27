class MinilangError < StandardError; end
class BadTokenError < MinilangError; end
class EmptyStackError < MinilangError; end


class Minilang
  TOKENS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)


  def initialize(program)
    @program = program
    @register = 0
    @stack = []
  end

  def eval_tokens(token)
    #evaluate what the tokens are, format and pass the argument
    if TOKENS.include?(token)
      send(token.downcase)
    elsif token =~ /\A[-+]?\d+\z/
      @register = token.to_i
    else
      raise BadTokenError, "Invalid token #{token}. Please change"
    end
  end

  def eval
    @program.split.each { |token| eval_tokens(token)}
    rescue MinilangError => error
      puts error.message
  end

  def push 
    @stack.push(@register)
  end

  def add
    @register += @stack.pop
  end

  def sub 
    @register -= @stack.pop
  end

  def mult 
    @register *= @stack.pop
  end

  def div
    @register /= @stack.pop
  end

  def mod
    @register %= @stack.pop
  end

  def pop
    raise EmptyStackError, "Empty Stack!" if @stack.empty?
    @register = @stack.pop
  end

  def print
    puts @register
  end

end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

 Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

 Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

 Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

 Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

 Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

 Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

 Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

 Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)