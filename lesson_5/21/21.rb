require 'pry'
require 'yaml'

DISPLAY_TEXT = YAML.load_file('21.yml')
DECK_CHOICES = ["🐖", "👹", "🤖", "👻", "💀", "🎃", "🧠", "🧟"]

module Displayable

  def prompt(key)
    display_item = DISPLAY_TEXT[key]
    puts display_item
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
    animate = "#{' ' * 60} 🐖🧟 "
    until animate.size == 0
      sleep 0.02
      print "\r"
      print(animate)
      animate = animate.chars
      animate.shift
      animate = animate.join
    end
    puts
  end

  def clear
    system 'clear'
  end

  def display_rules
    puts "Do you want to see the rules?"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y', 'n', 'yes', 'no'].include?(answer)
      puts "Invalid input"
    end
    prompt "rules" if answer.start_with?('y') 
  end

  def generate_card_display
    hsh = {:line1 => [], :line2 => [], :line3 => [], :line4 => [],:line5 => [], :line6 => [], :line7 => []}
    counter = 0
    print "\r"
    self.hand.size.times do 
    hsh[:line1] << " ________ " 
    hsh[:line2] << "|#{self.hand[counter].suit}     #{Deck.style}|"
    hsh[:line3] << "|        |"
    hsh[:line4] << "|#{self.hand[counter]} |"
    hsh[:line5] << "|        |"
    hsh[:line6] << "|#{Deck.style}     #{self.hand[counter].suit}|"
    hsh[:line7] << " -------- "
    counter += 1
    end
    hsh.values
  end

  def display_cards 
    puts "#{self.name}'s hand:"
    generate_card_display.each do |line|
      puts line.join(" ")
    end

    if calculate_total > 21 
      puts "#{self.name} Busted!"
    else
      puts "#{self.name} is at: #{calculate_total}"
    end
    puts
  end

  def dealers_hand
    puts
    self.update_total
    puts "#{self.name}'s hand:"
    card = self.hand[1]

      puts " ________   ________"
      puts "|#{card.suit}     #{Deck.style}| |#{Deck.style}    #{Deck.style}|"
      puts "|        | |        |"
      puts "|#{card} | |  CARD  |"
      puts "|        | |        |"
      puts "|#{Deck.style}     #{card.suit}| |#{Deck.style}    #{Deck.style}|"
      puts " --------   --------"
      puts
  end

  def calculate_total
    total = 0
    self.hand.each do |card|
      if card.ace?
        total += 11
      elsif card.royal?
        total +=10
      else
        total += card.face.to_i
      end
    end

    self.hand.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end

    update_total = total
    total
  end

  def thinking
    3.times do
      print "\r"
      print "🧠👀 #{dealer.name} is thinking."
      sleep 0.2
      print "\r"
      print "🧠👀 #{dealer.name} is thinking.."
      sleep 0.2
      print "\r"
      print "🧠👀 #{dealer.name} is thinking..."
      sleep 0.2
    end
  end
end
  
  class Participant
  include Displayable
  attr_accessor :hand, :name, :total

  def initialize
    @hand = []
    set_name
    total = 0
  end

  def add_card(new_card)
    @hand << new_card
  end

  def update_total
    @total = self.calculate_total
  end

  def total
    update_total
    @total
  end

  def busted?
    self.calculate_total > 21
  end

end

class Player < Participant

  def set_name
    name = ''
    puts "What's your name?"
    loop do 
      name = gets.chomp.capitalize
      break if name.to_s.strip == name
      puts "Invalid input"
    end
    self.name = name
  end
end

class Dealer < Participant

  def initialize
    @hand = []
    @name = "Dealer"
    total = 0
  end
end

class Deck
  CARDS = [' 2', ' 3', ' 4', ' 5', ' 6', ' 7', ' 8', ' 9', '10', ' J', ' Q', ' K', ' A']
  SUITS = %w( ♥ ♠ ♦ ♣)
  include Displayable
  attr_accessor :cards

  def initialize
    @cards = []
    SUITS.each do |suit|
      CARDS.each do |face|
        @cards << Card.new(suit, face)
      end
    end

    scramble!
    @@style = 🐖
  end

  def choose_deck_style
    answer = nil
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

  def self.choose_style 
    @@style = choose_deck_style
  end
  
  def scramble!
    cards.shuffle!
  end

  def deal
    cards.pop
  end

end

class Card

  attr_accessor :suit, :face

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def ace?
    self.face == " A"
  end

  def royal?
    %w(K Q J).include?(self.face.strip)
  end

  # def value
  #   if self.royal?
  #     10
  #   elsif ace?
  #     self.ace_value
  #   else
  #     card.face.to_i
  #   end
  # end

  def to_s
    "#{face} of #{suit}"
  end
end

class GameEngine
  include Displayable

  attr_accessor :deck, :player, :dealer

  def initialize
    welcome_display
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    display_rules 
    loop do 
      deal_cards
      clear
      player_turn
      clear
      if player.busted?
        show_cards
        show_result
        if play_again?
          reset
          next
        else
          break
        end
      end

      dealer_turn
      if dealer.busted?
        if play_again?
          reset
          next
        else
          break
        end
      end

      show_cards
      show_result
      play_again? ? reset : break
      # score
    end
    display_goodbye_message
  end

  def play_again?
    answer = nil
    puts "Do you want to play another hand?"
    loop do 
      answer = gets.chomp.downcase
      break if ['yes', 'y', 'n' , 'no'].include?(answer)
      puts "Invalid input"
    end
    puts
    answer.start_with?('y')
  end

  def deal_cards
    2.times do
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
    end
  end

  def reset
    player.total = 0
    player.hand = []
    dealer.total = 0
    dealer.hand = []
    @deck = Deck.new
  end

  def player_turn
    loop do
      dealer.dealers_hand
      player.display_cards
      answer = nil
      puts "Hit or Stay?(h/s)"
      loop do
        answer = gets.chomp.downcase
        break if ['h', 's', 'hit', 'stay'].include?(answer)
        puts "You gotta say hit or stay!!!"
      end
      if answer.start_with?('s')
        puts "#{player.name} stays"
        break
      elsif player.busted?
        clear
        break
      else
        sleep 0.2
        player.add_card(deck.deal)
        break if player.busted?
        clear
      end
    end
  end


  def dealer_turn
    thinking()
    sleep 1
    loop do
      if dealer.total > 16 && !dealer.busted?
        puts "#{dealer.name} choose to stay."
        sleep 1
        clear
        break
      elsif dealer.busted?
        break
      else
        dealer.add_card(deck.deal)
        clear
        dealer.display_cards
        player.display_cards
        sleep 1
      end
    end
  end

  def show_score
    puts "#{player.name} total: #{player.total}"
    puts "#{dealer.name} total: #{dealer.total}"
  end

  def show_cards
    dealer.display_cards
    player.display_cards
  end

  def show_result
    if player.busted? && !dealer.busted?
      puts "Dealer wins! #{player.name} busted!"
    elsif dealer.busted? && !player.busted?
      puts "You win! Dealer busted!"
    elsif player.total > dealer.total
      puts "#{player.name} takes this hand"
    elsif player.total < dealer.total
      puts "#{dealer.name} takes this hand!"  
    else
      puts "All tied up!"
    end
    puts
    show_score
  end
end



GameEngine.new.start
