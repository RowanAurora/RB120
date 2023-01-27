class GuessingGame
  def initialize(num1, num2)
    @num1 = num1
    @num2 = num2
    @range = (num1..num2).to_a
    @winning_num = 0
    @guesses = guess_number_eq((num1..num2).to_a.size)
  end

  def guess_number_eq(num)
    Math.log2(num).to_i + 1
  end

  def play
    @winning_num = @range.sample
    puts "Welcome to guess the number i guess"
    loop do
      puts "You have #{@guesses} guesses remaining"
      answer = number_loop
      evaluate_number(answer)
      break if win?(answer)
      @guesses -= 1
      break if lose?(answer)
    end
    puts "Goobye!"
  end

  def number_loop
    answer = nil
    loop do
      puts "Enter a number between #{@num1}  and #{@num2}"
      answer = gets.chomp.to_i
      break if @range.include?(answer)
      puts "Enter a a number between 1 and 100 please"
    end
    answer
  end

  def win?(answer)
    answer == @winning_num
  end

  def lose?(answer)
   if @guesses == 0
    puts "You lose!"
    true
   else
    false
   end
  end

  def evaluate_number(answer)
    if answer > @winning_num 
      puts "Too High!"
    elsif answer < @winning_num 
      puts "Too low!"
    else 
       puts "You won!"
    end
  end

end

game = GuessingGame.new(501, 1500)
game.play
game.play

