require 'pry'
require 'yaml'

DISPLAY_TEXT = YAML.load_file('ttt.yml')

MARKERS = ["⚔️ ", "🐖", "🤴", "🧌 ", "🧝", "🧙", "🐲", "🍄", "🛡 ", "💣", "🧜", "⚧ " ]
class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  attr_accessor :squares
  def initialize
    @squares = {}
    reset
  end

  def draw
    board_arr = ["     |     |",
    "  #{@squares[1]} |  #{@squares[2]} |  #{@squares[3]}",
    "     |     |", "-----+-----+-----", "     |     |",
    "  #{@squares[4]} |  #{@squares[5]} |  #{@squares[6]}",
    "     |     |", "-----+-----+-----", "     |     |",
    "  #{@squares[7]} |  #{@squares[8]} |  #{@squares[9]}",
    "     |     |"]
    board_arr.each { |line| puts line }
  end
  
  def []=(key, marker)
    @squares[key].marker = marker
  end
  
  def [](key)
    @squares[key].marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end
  
  def full?
    unmarked_keys.empty?
  end
  
  def someone_won?
    !!winning_marker
  end
  
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def find_at_risk_square
    WINNING_LINES.each do |line|
      square = @squares.values_at(*line)
      if two_full_squares?(square, Markers.human_marker)
        line.each do |k|
          return k if @squares[k].unmarked?
        end
      end
    end
    nil
  end
  
  def find_winner_square
      WINNING_LINES.each do |line|
        square = @squares.values_at(*line)
        if two_full_squares?(square, Markers.computer_marker)
          line.each do |k|
            return k if @squares[k].unmarked?
          end
        end
      end
      nil
    end

  def two_full_squares?(square, mark)
    square.count { |sqr| sqr.marker == mark} == 2
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = '  '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  PLAYSTYLES = ['Peasant', 'Paladin', 'Warrior', 'Mage', 'Wizard', "Lich"]

  attr_reader :marker, :name
  attr_accessor :score, :computer_play_style

  def initialize(marker, player_type = :human)
    @marker = marker
    @player_type = player_type
    @score = 0
    @name = nil
    @computer_play_style = nil
  end

  def choose_your_name
    answer = nil
    loop do
      puts "Choose your name!"
        answer = gets.chomp.capitalize
        break if answer.to_s == answer
    end
    @name = answer
  end

  def choose_computer_playstyle
    answer = nil
    puts "Choose the computer's play style:"
    PLAYSTYLES.each {| word| puts word }
    loop do
      answer = gets.chomp.capitalize
      break if PLAYSTYLES.include?(answer)
      puts "Invalid input"
    end
    @name = answer
    @computer_play_style = answer
  end

  def update_marker
    @marker = Markers.human_marker
  end

  def update_computer_marker
    @marker = Markers.computer_marker
  end 

  private

  def human?
    @player_type = :human
  end
end

module Playstyleable

  def defensive_moves
    move = board.find_at_risk_square
    if move
        board[board.find_at_risk_square] = Markers.computer_marker
    else
        board[board.unmarked_keys.sample] = Markers.computer_marker
    end
  end

  def offensive_moves
    move = board.find_winner_square
    if move
        board[board.find_winner_square] = Markers.computer_marker
    else
        board[board.unmarked_keys.sample] = Markers.computer_marker
    end
  end

  def hard_moves
    if board.find_at_risk_square
      board[board.find_at_risk_square] = Markers.computer_marker
    else 
      offensive_moves
    end
  end
  
  def extra_hard_moves
    if board.find_winner_square
        board[board.find_winner_square] = Markers.computer_marker
    else
      defensive_moves
    end
  end

  def regular_moves
    board[board.unmarked_keys.sample] = Markers.computer_marker
  end

  def best_moves
    if board[5] == Square::INITIAL_MARKER
      board[5] = Markers.computer_marker
    else 
      extra_hard_moves
    end
  end

end

# module for display-type methods for TTTGame
module Displayable
  def display_result
    display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
      score_update(human)
    when computer.marker
      puts "The #{computer.name} Won!"
      score_update(computer)
    else
      puts "The board is full!"
    end
  end

  def clear
    system 'clear'
  end

  def display_score
    puts "#{human.name} score: #{human.score}"
    puts "The #{computer.name}'s score: #{computer.score}"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe. BYE"
  end

  def display_welcome_message
    puts " Welcome to Tic Tac toe"
    puts
  end

  def clear_screen_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{human.marker}."
    puts "Computer is a #{computer.marker}"
    puts
    board.draw
    puts
  end

  def joinor(squares_left)
    case squares_left.size
    when 0 then ''
    when 1 then squares_left.first.to_s
    when 2 then squares_left.join(JOIN_WORD)
    else 
      squares_left[-1] = "#{JOIN_WORD} #{squares_left.last}"
      squares_left.join(", ")
    end
  end

  def reset
    board.reset
    clear
    puts "Let's play again!"
    puts
  end
end

class Markers # Class for custom markers. Class variables to allow easy access in other classes - dependancy throughout but dont want dynamic assignment constant
  attr_reader :human_marker
  attr_accessor :computer_marker
  def initialize
    @@human_marker = custom_marker
    @@computer_marker = remaining_marker
  end
  
  def self.human_marker 
    @@human_marker
  end

  def self.computer_marker
    @@computer_marker
  end

  def custom_marker
    answer = nil
    puts "Custom Marker:"
    display_marker_choices
    loop do
      answer = gets.chomp.to_i
      break if (1..MARKERS.size).to_a.include?(answer)
      puts "invalid choice"
    end
    @@human_marker = MARKERS[answer - 1]
  end
 
  private

  def remaining_marker
    loop do
      @@computer_marker = MARKERS.sample
      break if @@computer_marker != @@human_marker
    end
    @@computer_marker
  end

  def display_marker_choices # maybe better in Displayable?
    MARKERS.each_with_index do |mark, idx|
      puts "#{idx + 1} : #{mark}"
    end
  end
end
  

class TTTGame
  include Playstyleable
  include Displayable
  JOIN_WORD = 'or'
  

  attr_reader :board, :human, :computer, :marker
  attr_accessor :switch, :human_marker



  def initialize
    @board = Board.new
    @human = Player.new("X ")
    @computer = Player.new("O ", :computer)
    @switch = true # true is for human, false for computer
  end

  def play
    clear
    intro
    loop do
      display_board
      move_section(switch)
      display_result
      display_score
      break unless play_again?
      reset
    end

    display_goodbye_message
  end

  private
  
  def intro
    display_welcome_message
    human.choose_your_name
    Markers.new
    human.update_marker
    computer.update_computer_marker
    computer.choose_computer_playstyle
  end

  def move_section(switch)
    loop do
      current_player_moves(switch)
      switch = !switch
      break if board.someone_won? || board.full?
      clear_screen_display_board
    end
  end

  def joinor(squares_left)
    case squares_left.size
    when 0 then ''
    when 1 then squares_left.first.to_s
    when 2 then squares_left.join(JOIN_WORD)
    else 
      squares_left[-1] = "#{JOIN_WORD} #{squares_left.last}"
      squares_left.join(", ")
    end
  end

  def human_moves
    puts "Choose a square: #{joinor(board.unmarked_keys)} "
    square = ''
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice"
    end
    board[square] = Markers.human_marker
  end

  def computer_moves
    case computer.computer_play_style
    when 'Peasant' then regular_moves
    when 'Paladin' then defensive_moves
    when 'Warrior' then offensive_moves
    when "Mage" then hard_moves
    when "Wizard" then extra_hard_moves
    when "Lich" then best_moves
    end
  end

  def score_update(player)
    player.score +=1
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?(y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'yes', 'n', 'no'].include?(answer)
      puts "Sorry must be Yes or No"
    end
    answer.start_with?('y')
  end



  def current_player_moves(switch)
    switch ? human_moves : computer_moves
  end
end

game = TTTGame.new
game.play
