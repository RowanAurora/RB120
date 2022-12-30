require 'yaml'
LANGUAGE = 'en'
MESSAGES = YAML.load_file('rps.yml')
ROUNDS_TO_WIN = 3

module Formatable
  def to_s
    self.class.to_s.split("::")[-1]
  end
end

module Displayable
  VALID = ['y', 'yes', 'n', 'no']
  ANIMATE_TEXT = ["ROCK", "PAPER", "SCISSORS", "LIZARD", "SPOCK", "GO!"]
  LOSE_GRAPHIC = [%( .  _.-^^---....,,--_^ ), %( _--                  L--_),
                  %(<                        \>), %(|                         |),
                  %( L._                   _./), %(    ```--. . , ; .--''' ),
                  %(          | |   |        ), %(       .-=||  | |=-.   ),
                  %(       `-=#$%&%$#=-'   ), %(          | ;  :|     ),
                  %( _____.,-#%&$@%#&#~,._____)]

  def messages(message, lang='en')
    MESSAGES[lang][message]
  end

  def prompt(key)
    message = messages(key, LANGUAGE)
    puts message
  end

  def text_animation
    0.upto(5) do |i|
      sleep 0.2
      print "\r"
      print format("%20s", ANIMATE_TEXT[i])
    end
    sleep 0.5
    puts
  end

  def display_welcome_message
    puts
    prompt "welcome"
    prompt "title_one"
    prompt "title_two"
    puts
  end

  def rules_set
    prompt "rule1"
    prompt "rule2"
    puts
    prompt "rule3"
    prompt "rule4"
    puts "Get #{ROUNDS_TO_WIN} wins before the computer to stop the apocalypse"
    puts
  end

  def display_rules
    prompt "rules"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      puts
      break if VALID.include?(answer)
      prompt "yesno"
    end
    rules_set if answer.start_with?('y')
  end

  def display_goodbye_message
    puts
    prompt "bye"
  end

  def move_display
    puts
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  
  def display_winner
    if human_won?
      puts "#{human.name} won this battle!"
    elsif computer_won?
      puts "#{computer.name} defeated you!"
    else
      prompt "tie"
    end
  end
  
  def hero_display
    if grand_winner(human)
      prompt "win"
    elsif grand_winner(computer)
      bomb()
      prompt "lose"
      forced_name_changer
    end
  end
  
  
  def score_display
    puts "#{human.name} score : #{human.score}"
    puts "#{computer.name} score : #{computer.score}"
  end
  
  def move_history_display
    prompt "move_history"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      puts
      break if VALID.include?(answer)
      prompt "yesno"
    end
    puts @move_history if answer.start_with?('y')
  end
  private
  
  def grand_winner(player)
    player.score == ROUNDS_TO_WIN
  end
  
  def forced_name_changer
    human.name = messages "hero"
    computer.name = messages "lord"
  end

  def bomb
    LOSE_GRAPHIC.each { |line| puts line }
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
    private
    WINS = ['scissors', 'lizard']
  end

  class Paper < Move
    private
    WINS = ['rock', 'spock']
  end

  class Scissors < Move
    private
    WINS = ['paper', 'lizard']
  end

  class Lizard < Move
    private
    WINS = ['spock', 'paper']
  end

  class Spock < Move
    private
    WINS = ['scissors', 'rock']
  end
end

module Players
  class Player
    include Displayable
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
        prompt "name"
        n = gets.chomp
        break unless n.empty?
        prompt "sorry_name"
      end
      self.name = n
    end

    def choose
      choice = nil
      loop do
        puts
        prompt "pick"
        choice = gets.chomp.downcase
        break if MOVE_INPUT.keys.include? choice
        prompt "not_valid"
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
    FETCH = MOVE_INPUT[Moves::Move::VALUES.sample]
    include Formatable

    private
    def set_name
      self.name = to_s
    end
  end

  class Printer < Computer
    def choose
      self.move = MOVE_INPUT['paper']
    end
  end

  class Edi < Computer
    def choose
      self.move = FETCH
    end
  end

  class Hades < Computer
    def choose
      self.move = FETCH
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
  
  def play
    loop do
      move_section
      display_section
      break unless play_again?
    end
    move_history_display
    display_goodbye_message
  end
  
  
  def human_won?
    human.move > computer.move
  end
  
  def computer_won?
    computer.move > human.move
  end
  
  
  
  private
  def enemy
    n = pick_enemy
    case n
    when 'Edi' then Players::Edi.new
    when 'Hades' then Players::Hades.new
    when 'Watson' then Players::Watson.new
    when 'Printer' then Players::Printer.new
    end
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
      prompt "again"
      answer = gets.chomp.downcase
      break if ['yes', 'y', 'no', 'n'].include?(answer)
      prompt "yesno"
    end
    answer.start_with?('y')
  end

  def display_section
    text_animation
    move_display
    puts
    score_update
    display_winner
    hero_display
    puts
    score_display
    puts
  end
  
  def move_section
    human.choose
    computer.choose
    movekeep
  end
  
  def pick_enemy
    n = nil
    loop do
      puts
      prompt "enemy"
      n = gets.chomp.capitalize
      break if Players::Computer::NAMES.include?(n)
      prompt "valid_enemy"
    end
    n
  end
end

RPSGame.new.play
