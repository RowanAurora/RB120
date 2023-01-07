require 'yaml'

DISPLAY_TEXT = YAML.load_file('21.yml')
DECK_CHOICES = ["🐖", "👹", "🤖", "👻", "💀", "🎃", "🧠", "🧟"]
DISPLAY_WIDTH = 80

module Displayable
  def prompt(key)
    display_item = DISPLAY_TEXT[key]
    puts display_item.center(DISPLAY_WIDTH)
  end

  def player_turn_card_display
    puts
    puts "#{dealer.name}'s hand:".center(DISPLAY_WIDTH)
    dealer.card_down_hand
    player.display_cards
  end

  def welcome_display
    clear
    prompt "start_graphic"
    puts
    prompt "welcome"
    puts
  end

  def rules_set
    prompt 'rules'
  end

  def display_goodbye_message
    prompt "bye"
    text_animation
  end

  def display_rules
    puts
    prompt 'see_rules'
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      prompt 'invalid'
    end
    prompt "rules" if answer.start_with?('y')
  end

  def display_cards
    puts "#{name}'s hand:"
    generate_card_display.each { |line| puts line.join(" ") }
    puts

    if calculate_total > 21
      puts "#{name} Busted!"
    else
      puts "#{name} is at: #{calculate_total}"
    end
    puts
    sleep 0.1
  end

  def card_down_hand
    card = hand[1]
    icon = Deck.style
    puts " ________   ________"
    puts "|#{card.suit}     #{icon}| |#{icon}    #{icon}|"
    puts "|        | |        |"
    puts "|#{card} | |  CARD  |"
    puts "|        | |        |"
    puts "|#{icon}     #{card.suit}| |#{icon}    #{icon}|"
    puts " --------   --------"
    puts
  end

  def show_score
    puts "#{player.name} total: #{player.calculate_total}"
    puts "#{dealer.name} total: #{dealer.calculate_total}"
  end

  def beat_or_bust(win, lose)
    if lose.busted?
      puts "#{win.name} wins! #{lose.name} busted!"
    else
      puts "#{win.name} takes this hand!"
    end
  end

  def show_result
    if dealer_win_check
      beat_or_bust(dealer, player)
    elsif player_win_check
      beat_or_bust(player, dealer)
    else
      prompt 'tied'
    end
    puts
    show_score
  end
end

module Animateable
  def dealing_animation
    animate = "🧠👀 #{dealer.name} is dealing."
    3.times do
      print "\r"
      print animate
      animate << '.'
      sleep 0.2
    end
  end

  def dealing
    puts
    3.times do
      dealing_animation
    end
    clear
  end

  def text_animation
    animate = "#{' ' * 60} 🐖 🧟 "
    until animate.size == 1
      sleep 0.03
      print "\r"
      print(animate)
      animate = animate.chars
      animate.shift
      animate[-3] = animate.shift if animate.size > 4
      animate = animate.join
    end
  end
  puts
end

module Functionable
  def clear
    system 'clear'
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def generate_card_display
    hsh = { line1: [], line2: [], line3: [], line4: [], line5: [],
            line6: [], line7: [] }
    counter = 0
    print "\r"
    hand.size.times do
      hsh[:line1] << " ________ "
      hsh[:line2] << "|#{hand[counter].suit}     #{Deck.style}|"
      hsh[:line3] << "|        |"
      hsh[:line4] << "|#{hand[counter]} |"
      hsh[:line5] << "|        |"
      hsh[:line6] << "|#{Deck.style}     #{hand[counter].suit}|"
      hsh[:line7] << " -------- "
      counter += 1
    end
    hsh.values
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def calculate_total
    total = 0
    hand.each do |card|
      total += if card.ace?
                 11
               elsif card.royal?
                 10
               else
                 card.face.to_i
               end
    end

    hand.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end

    total
  end
  # rubocop:enable Metrics/MethodLength

  def dealer_win_check
    (player.busted? && !dealer.busted?) ||
      (player.calculate_total < dealer.calculate_total)
  end

  def player_win_check
    (dealer.busted? && !player.busted?) ||
      (player.calculate_total > dealer.calculate_total)
  end
end

class Participant
  include Displayable
  include Functionable
  attr_accessor :hand, :name

  def initialize
    @hand = []
    set_name
  end

  def add_card(new_card)
    @hand << new_card
  end

  def busted?
    calculate_total > 21
  end
end

class Player < Participant
  def set_name
    name = ''
    prompt "name"
    loop do
      name = gets.chomp.capitalize
      break if name.to_s.strip == name
      prompt 'invalid'
    end
    self.name = name
  end
end

class Dealer < Participant
  def initialize
    @hand = []
    @name = "Zombie Dealer"
  end
end

class Deck
  CARDS = [' 2', ' 3', ' 4', ' 5', ' 6', ' 7', ' 8', ' 9', '10', ' J', ' Q',
           ' K', ' A']
  SUITS = %w(♥ ♠ ♦ ♣)

  include Displayable
  include Functionable
  attr_accessor :cards

  def initialize(style)
    @cards = []
    SUITS.each do |suit|
      CARDS.each do |face|
        @cards << Card.new(suit, face)
      end
    end

    scramble!
    @@style = style
  end

  def choose_deck_style
    answer = nil
    puts
    prompt "choose_deck"
    prompt 'deck_choices'
    loop do
      answer = gets.chomp.to_i
      break if (1..8).to_a.include?(answer)
      prompt "invalid"
    end
    DECK_CHOICES[answer - 1]
  end

  def self.style
    @@style
  end

  def choose_style
    @@style = choose_deck_style
  end

  def deal
    cards.pop
  end

  private

  def scramble!
    cards.shuffle!
  end
end

class Card
  attr_reader :suit, :face

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def ace?
    face == " A"
  end

  def royal?
    %w(K Q J).include?(face.strip)
  end

  def to_s
    "#{face} of #{suit}"
  end
end

class GameEngine
  include Displayable
  include Functionable
  include Animateable

  attr_accessor :deck, :player, :dealer

  def initialize
    welcome_display
    @deck = Deck.new('bob')
    @player = Player.new
    @dealer = Dealer.new
  end

  # rubocop:disable Metrics/MethodLength
  def play_game
    opening
    loop do
      clear
      player_section
      if player.busted?
        cards_and_results
        break unless play_again?
        ending
        next
      end
      if dealer_turn?
        break unless play_again?
        ending
        next
      end

      cards_and_results
      break unless play_again?
      ending
    end
    display_goodbye_message
  end
  # rubocop:enable Metrics/MethodLength

  private

  def opening
    display_rules
    deck.choose_style
  end

  def ending
    text_animation
    sleep 0.2
    reset
  end

  def player_section
    deal_cards
    clear
    player_turn
  end

  def play_again?
    answer = nil
    puts
    puts "Do you want to play another hand?"
    loop do
      answer = gets.chomp.downcase
      break if ['yes', 'y', 'n', 'no'].include?(answer)
      prompt 'invalid'
    end
    reset if answer.start_with?('y')
    answer.start_with?('y')
  end

  def deal_cards
    2.times do
      player.add_card(deck.deal)
      dealer.add_card(deck.deal)
    end
  end

  def reset
    player.hand = []
    dealer.hand = []
    @deck = Deck.new(Deck.style)
  end

  def dealer_stays
    puts "#{dealer.name} choose to stay."
    sleep 0.5
    clear
  end

  def dealer_hit
    dealer.add_card(deck.deal)
    clear
    dealer.display_cards
    player.display_cards
    sleep 1
  end

  def player_hit
    sleep 0.2
    player.add_card(deck.deal)
    clear
  end

  def hit_stay_loop
    answer = nil
    puts "Hit or Stay?(h/s)"
    loop do
      answer = gets.chomp.downcase
      break if ['h', 's', 'hit', 'stay'].include?(answer)
      prompt 'hit_or_stay'
    end
    answer
  end

  # rubocop:disable Metrics/MethodLength
  def player_turn
    loop do
      break if player.busted?
      player_turn_card_display
      if hit_stay_loop.start_with?('s')
        puts
        puts "#{player.name} stays"
        break
      else
        player_hit
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def dealer_turn?
    dealing()
    loop do
     if dealer.calculate_total > 16 && !dealer.busted?
      dealer_stays
      break
     end
      break if dealer.busted?
      dealer_hit
    end
      dealer.busted?
  end

  def cards_and_results
    show_cards
    show_result
  end

  def show_cards
    dealer.display_cards
    player.display_cards
  end
end

GameEngine.new.play_game
