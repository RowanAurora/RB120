require 'pry'
module Formatable
  def to_s
    self.class.to_s.split("::")[-1]
  end
end

module Displayable
  VALID = ['y', 'yes', 'n', 'no']
  ROUNDS = 5
  ANIMATE_TEXT =["ROCK", "PAPER", "SCISSORS", "LIZARD", "SPOCK", "GO!"]
  
  def word_line_boogie
    counter = 0
    
    6.times do 
      sleep 0.3
      print "\r"
      print sprintf("%20s", ANIMATE_TEXT[counter])
      counter += 1
      # case counter
      # when 0
      #   counter += 1
      #   print "        ROCK       "
      # when 1
      #   counter += 1
      #   print "       PAPER       "
      # when 2
      #   counter += 1
      #   print "      SCISSORS     "
      # when 3
      #   counter += 1
      #   print "       LIZARD      "
      # when 4
      #   counter += 1
      #   print "       SPOCK       "
      # when 5  
      #   counter += 1
      #   print "        GO!          "
      #   sleep 0.5
      # end
    end
    sleep 0.5
    puts
  end

  def display_welcome_message
    puts 
    puts "----------------ROCK  PAPER  SCISSORS  LIZARD  SPOCK------------------"
    puts "█▀█ █ █▀ █▀▀   █▀█ █▀▀   ▀█▀ █░█ █▀▀   █▀▄▀█ ▄▀█ █▀▀ █░█ █ █▄░█ █▀▀ █▀"
    puts "█▀▄ █ ▄█ ██▄   █▄█ █▀░   ░█░ █▀█ ██▄   █░▀░█ █▀█ █▄▄ █▀█ █ █░▀█ ██▄ ▄█"
    puts
  end
  
  def display_rules 
    puts "Would You like to see the rules?(y/n)"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if VALID.include?(answer)
      puts "Please input yes or no"
    end
    if answer.start_with?('y')
      puts "Scissors cuts Paper covers Rock crushes Lizard poisons Spock smashes Scissors "
      puts "decapitates Lizard eats Paper disproves Spock vaporizes Rock crushes Scissors"
      puts "First, pick your name. Then, choose your opponant."
      puts "Enter your move by typing one of the choices Rock, Paper, Scissors, Lizard, Spock"
      puts "Get #{ROUNDS} wins before the computer to stop the apocalypse"
    end
  end

  def display_goodbye_message
    puts
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Bye!"
  end

  def move_display
    puts
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def bomb 
    puts %( .  _.-^^---....,,--_n )       
    puts %( _--                  L--_)  
    puts %(<                        >)
    puts %(|                         |) 
    puts %( L._                   _./)  
    puts %(    ```--. . , ; .--''' )      
    puts %(          | |   |        )     
    puts %(       .-=||  | |=-.   )
    puts %(       `-=#$%&%$#=-'   )
    puts %(          | ;  :|     )
    puts %( _____.,-#%&$@%#&#~,._____)
  end
  
  def display_winner
    if human_won?
      puts "#{human.name} won this battle!"
    elsif computer_won?
      puts "#{computer.name} defeated you!"
    else
      puts "It's a tie!"
    end
  end

  def hero_display
    if human.score == ROUNDS
      puts "You saved the world! Now the terminators are coming for you."
    elsif computer.score == ROUNDS
      bomb()
      puts "You failed to save the world! Fight for you new overlord's amusement."
      human.name = "Wastelander"
      computer.name = "SUPREME OVERLORD"
    end
  end

  def score_display
    puts "#{human.name} score : #{human.score}"
    puts "#{computer.name} score : #{computer.score}"
  end

  def move_history_display
    puts 'Would you like to see the move history?(y/n)'
    answer = nil
    loop do 
      answer = gets.chomp.downcase
      puts
      break if VALID.include?(answer)
      puts "Please input yes or no"
    end
      puts @move_history if answer.start_with?('y') 
  end
end

module Moves
  class Move
    include Formatable
    VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
    DANGER = ['scissors', 'lizard', 'rock']

    def >(other_move)
     self.class::WINS.include?(other_move.to_s.downcase)
    end
  end

  class Rock < Move
    WINS = ['scissors', 'lizard']
    LOSES = ['paper', 'spock']
  end

  class Paper < Move
    WINS = ['rock', 'spock']
    LOSES = ['scissors', 'lizard']
  end

  class Scissors < Move
    WINS = ['paper', 'lizard']
    LOSES = ['rock', 'spock']
  end

  class Lizard < Move
    WINS = ['spock', 'paper']
    LOSES = ['rock', 'scissors']
  end

  class Spock < Move
    WINS = ['scissors', 'rock']
    LOSES = ['lizard', 'paper']
  end
end

module Players 

  class Player
    attr_accessor :move, :name, :score

    MOVE_INPUT = {
      'rock' => Moves::Rock.new,
      'paper' => Moves::Paper.new,
      'scissors' => Moves::Scissors.new,
      'lizard' => Moves::Lizard.new,
      'spock' => Moves::Spock.new
    }
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
        break if MOVE_INPUT.keys.include? choice
        puts "Sorry, invalid input"
      end
      @@choice = choice
      self.move = MOVE_INPUT[choice]
    end

    def self.human_move
      @@choice
    end
  end

  class Computer < Player
    NAMES = ["Edi", "Hades", "Watson", 'Printer']
    include Formatable

    def set_name
      self.name = self.to_s
    end

  end

  class Printer < Computer
    def choose
      self.move = MOVE_INPUT['paper']
    end
  end

  class Edi < Computer
    def choose
      self.move = MOVE_INPUT[Moves::Move::VALUES.sample]
    end
  end

  class Hades < Computer
    def choose 
      self.move = MOVE_INPUT[Moves::Move::DANGER.sample]
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
      self.move = MOVE_INPUT[(LOOSERS[Human.human_move].sample)]
    end
  end
end

module Movestorable
  def movekeep
    @move_history << ["#{human.name}: #{human.move}", 
      "#{computer.name}: #{computer.move}", '-----------']
  end
end

class RPSGame
  attr_accessor :human, :computer
  include Displayable
  include Movestorable
  def initialize
    display_welcome_message
    display_rules
    @human = Players::Human.new
    @computer = enemy
    @move_history = []
  end

  def pick_enemy
    n = nil
    loop do
      puts
      puts "Pick your opponant! Edi, Hades, Watson or Printer"
      n = gets.chomp.capitalize
      break if Players::Computer::NAMES.include?(n)
      puts "Sorry, must enter opponents name"
    end
    n
  end

  def enemy
    n = pick_enemy
    case n 
    when 'Edi'
      Players::Edi.new
    when 'Hades'
      Players::Hades.new
    when 'Watson'
      Players::Watson.new
    when 'Printer'
      Players::Printer.new
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
      movekeep
      word_line_boogie
      move_display
      puts 
      score_update
      display_winner
      hero_display
      puts 
      score_display
      puts
      break unless play_again?
    end
    move_history_display
    display_goodbye_message
  end
end

RPSGame.new.play
