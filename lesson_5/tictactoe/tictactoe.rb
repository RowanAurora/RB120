require 'yaml'
DISPLAY_TEXT = YAML.load_file('ttt.yml')

module Playstyleable
  def defensive_moves
    move = board.find_at_risk_square
    if move
      board[board.find_at_risk_square] = Player.computer_marker
    else
      board[board.unmarked_keys.sample] = Player.computer_marker
    end
  end

  def offensive_moves
    move = board.find_winner_square
    if move
      board[board.find_winner_square] = Player.computer_marker
    else
      board[board.unmarked_keys.sample] = Player.computer_marker
    end
  end

  def hard_moves
    if board.find_at_risk_square
      board[board.find_at_risk_square] = Player.computer_marker
    else
      offensive_moves
    end
  end

  def extra_hard_moves
    if board.find_winner_square
      board[board.find_winner_square] = Player.computer_marker
    else
      defensive_moves
    end
  end

  def regular_moves
    board[board.unmarked_keys.sample] = Player.computer_marker
  end

  def best_moves
    if board[5] == Square::INITIAL_MARKER
      board[5] = Player.computer_marker
    else
      extra_hard_moves
    end
  end
end

module Displayable
  JOIN_WORD = 'or'

  def fetch_key(string)
    DISPLAY_TEXT[string]
  end

  def prompt(string)
    fetch_text = fetch_key(string)
    puts fetch_text
  end

  # rubocop:disable Metrics\MethodLength
  def display_result
    clear_screen_display_board
    case board.winning_marker
    when Player.human_marker
      puts "#{' ' * (31 - human.name.size)}#{human.name} won!"
      score_update(human)
    when Player.computer_marker
      puts "#{' ' * (29 - computer.name.size)}The #{computer.name} Won!"
      score_update(computer)
    else
      prompt "full_board"
    end
  end
  # rubocop:enable Metrics\MethodLength

  def display_score
    puts
    puts "#{' ' * 24}  #{human.name} score: #{human.score}"
    puts "#{' ' * 23}The #{computer.name}'s score: #{computer.score}"
    puts
  end

  def display_goodbye_message
    prompt "goodbye"
    sleep 2
    text_animation
    clear
  end

  def display_welcome_message
    prompt "welcome"
    puts
  end

  def display_playstyle
    prompt "play_style"
  end

  def clear
    system 'clear'
  end

  def clear_screen_display_board
    clear
    display_board
  end

  def display_board
    puts
    puts "#{' ' * 18} You're #{Player.human_marker}" \
         "  Computer is  #{Player.computer_marker}"
    puts
    board.draw
    puts
  end

  def display_marker_choices
    prompt("icons")
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
    prompt "yes_play_again"
    sleep 0.1
    puts
  end

  def text_animation
    animate = "#{' ' * 60} 🐖"
    until animate.size == 1
      sleep 0.02
      print "\r"
      print(animate)
      animate = animate.chars
      animate.shift
      animate = animate.join
    end
    puts
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  attr_accessor :squares

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def draw
    puts "                             |     |"
    puts "                          #{@squares[1]}" \
    " |  #{@squares[2]} |  #{@squares[3]}"
    puts "                             |     |"
    puts "                        -----+-----+-----"
    puts "                             |     |"
    puts "                          #{@squares[4]} |  #{@squares[5]}" \
    " |  #{@squares[6]}"
    puts "                             |     |"
    puts "                 █▄██▄█ -----+-----+----- █▄██▄█"
    puts "        █▄█▄█▄█▄█▐█┼██▌      |     |      ▐█┼██▌█▄█▄█▄█▄█"
    puts "        ███┼█████▐████▌   #{@squares[7]} |  " \
    "#{@squares[8]} |  #{@squares[9]}  ▐████▌███┼█████"
    puts "        ████ ████▐████▌      |     |      ▐████▌█████ ███"
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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
      if two_full_squares?(square, Player.human_marker)
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
      if two_full_squares?(square, Player.computer_marker)
        line.each do |k|
          return k if @squares[k].unmarked?
        end
      end
    end
    nil
  end

  def two_full_squares?(square, mark)
    square.count { |sqr| sqr.marker == mark } == 2
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
  CUSTOM_MARKERS = ["⚔️ ", "🐖", "🤴", "🧌 ", "🧝", "👼", "🐲", "🍄", "🛡 ", "💣", "🧜",
                    "⚧ "]

  include Displayable

  attr_reader :name, :human_marker
  attr_accessor :score, :computer_play_style, :computer_marker

  def initialize(_marker, player_type = :human)
    @player_type = player_type
    @score = 0
    @name = nil
    @computer_play_style = nil
    @@human_marker = nil # Maybe weird choice class variable
    @@computer_marker = nil
  end

  def choose_your_name
    answer = nil
    loop do
      prompt "choose_name"
      answer = gets.chomp.capitalize
      puts
      break if answer.to_s.strip == answer
      prompt "invalid"
    end
    @name = answer
  end

  def choose_computer_playstyle
    answer = nil
    prompt "play_style_choose"
    display_playstyle
    loop do
      answer = gets.chomp.capitalize
      break if PLAYSTYLES.include?(answer)
      prompt "invalid"
    end
    @name = answer
    @computer_play_style = answer
  end

  def update_marker
    custom_marker
  end

  def custom_marker
    answer = nil
    prompt "custom_marker_question"
    display_marker_choices
    loop do
      answer = gets.chomp.to_i
      puts
      break if (1..CUSTOM_MARKERS.size).to_a.include?(answer)
      puts "invalid choice"
    end
    @@human_marker = CUSTOM_MARKERS[answer - 1]
  end

  def update_computer_marker
    case computer_play_style
    when 'Peasant' then @@computer_marker = "🌾"
    when 'Paladin' then @@computer_marker = "🙇"
    when 'Warrior' then @@computer_marker = "🗡 "
    when "Mage" then @@computer_marker = "🦹"
    when "Wizard" then @@computer_marker = "🧙"
    when "Lich" then @@computer_marker = "🧟"
    end
    @@computer_marker
  end

  def self.human_marker
    @@human_marker
  end

  def self.computer_marker
    @@computer_marker
  end

  private

  def human?
    @player_type = :human
  end
end

class TTTGame
  include Playstyleable
  include Displayable

  attr_reader :board, :human, :computer
  attr_accessor :switch

  def initialize
    @board = Board.new
    @human = Player.new("X ")
    @computer = Player.new("O ", :computer)
    @switch = true # true is for human, false for computer
  end

  def play
    intro
    loop do
      sleep 0.2
      clear_screen_display_board
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
    clear
    prompt "skull"
    puts
    prompt "opening_display"
    display_welcome_message
    human.choose_your_name
    human.update_marker
    computer.choose_computer_playstyle
    computer.update_computer_marker
  end

  def move_section(switch)
    loop do
      current_player_moves(switch)
      switch = !switch
      break if board.someone_won? || board.full?
      clear_screen_display_board
    end
  end

  def human_moves
    puts "#{' ' * 12} Choose a square: #{joinor(board.unmarked_keys)} "
    square = ''
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      prompt "invalid"
    end
    board[square] = Player.human_marker
  end

  def computer_moves
    sleep 0.5
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
    player.score += 1
  end

  def play_again?
    answer = nil
    loop do
      prompt "play_again?"
      answer = gets.chomp.downcase
      break if ['y', 'yes', 'n', 'no'].include?(answer)
      prompt "invalid"
    end
    answer.start_with?('y')
  end

  def current_player_moves(switch)
    switch ? human_moves : computer_moves
  end
end

game = TTTGame.new
game.play
