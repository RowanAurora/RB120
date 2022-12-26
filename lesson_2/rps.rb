class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  DANGER = ['scissors', 'lizard', 'rock']

  WINNERS = {
    'rock' => ['scissors', 'lizard'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['spock', 'paper'],
    'spock' => ['scissors', 'rock']
  }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNERS[self.to_s].include?(other_move.to_s)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  attr_accessor :choice
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a name"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts
      puts "Pick : Rock, Paper, Scissors, Lizard or Spock?"
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      puts "Sorry, invalid input"
    end
    @@choice = choice
    self.move = Move.new(choice)
  end

  def self.human_move
    @@choice
  end
end

class Computer < Player
  NAMES = ["Edi", "Hades", "Watson", 'Printer']

  def set_name
    self.name = self.class.to_s
  end

end

class Printer < Computer
  def initialize
    @name = 'Printer'
  end

  def choose
    self.move = Move.new('paper')
  end
end

class Edi < Computer
  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Hades < Computer
  def choose 
    self.move = Move.new(Move::DANGER.sample)
  end
end

class Watson < Computer
LOOSERS = {
  'rock' => ['paper', 'spock'],
  'paper' => ['scissors', 'lizard'],
  'scissors' => ['spock', 'rock'],
  'lizard' => ['rock', 'scissors'],
  'spock' => ['lizard', 'paper']
}

  def choose 
    self.move = Move.new(LOOSERS[Human.human_move].sample)
  end
end

module Displayable
  def display_welcome_message
    puts "----Welcome to Rock, Paper, Scissors, Lizard, Spock-----"
    puts "-----------------RISE OF THE MACHINES-------------------"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Bye!"
  end

  def move_display
    puts
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human_won?
      puts "#{human.name} won!"
    elsif computer_won?
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def score_display
    puts "#{human.name} score : #{human.score}"
    puts "#{computer.name} score : #{computer.score}"
  end
end

class RPSGame
  attr_accessor :human, :computer
  include Displayable
  def initialize
    display_welcome_message
    @human = Human.new
    @computer = enemy
  end

  def pick_enemy
    n = nil
    loop do
      puts
      puts "Pick your opponant! Edi, Hades, Watson or Printer"
      n = gets.chomp.capitalize
      break if Computer::NAMES.include?(n)
      puts "Sorry, must enter opponents name"
    end
    n
  end

  def enemy
    n = pick_enemy
    case n 
    when 'Edi'
      Edi.new
    when 'Hades'
      Hades.new
    when 'Watson'
      Watson.new
    when 'Printer'
      Printer.new
    end
  end

  def human_won?
     human.move > computer.move
  end

  def computer_won?
    computer.move > human.move
  end

  def score_update
    if human_won?
      human.score += 1
    elsif computer_won? 
      computer.score += 1
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?(y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "sorry, must be y or n"
    end
    answer == 'y'
  end

  def play
    loop do
      human.choose
      computer.choose
      move_display
      puts 
      score_update
      display_winner
      puts 
      score_display
      puts
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
