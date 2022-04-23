require_relative "player.rb"

class Ghost
  def initialize(players)
    # gubbins to get the dictionary set up
    dictionary = Hash.new(0)
    file = File.open("dictionary.txt")
    file_data  = file.readlines.map(&:chomp)
    file_data.each { |line| dictionary[line] += 1}

    @players = players
    @fragment = ""
    @dictionary = dictionary
    @current_player_index = 0
    @losses = Hash.new(0)
  end

  def run
    while @players.length != 1
      @fragment = ""
      play_round
      display_standings
      @players.each_with_index do |player, idx|
        if @losses[player.name] == 5
          @players.delete_at(idx)
        end
      end
    end
    puts @players[0].name + "WINS"
  end

  def display_standings
    puts "-----CURRENT STANDINGS-----"
    @losses.each do |k, v|
      puts "#{k} => #{v}"
    end
    puts "---------------------------"
  end

  def play_round
    while !completed?(@fragment)
      take_turn(current_player)
      next_player!
    end
    @losses[previous_player.name] += 1
  end

  def completed?(fragment)
    return false if @dictionary.keys.any? { |key| key[0...fragment.length] == fragment && key.length > fragment.length}
    true
  end

  def current_player
    @players[@current_player_index]
  end

  def previous_player
    @players[@current_player_index - 1]
  end

  def next_player!
    @current_player_index = (@current_player_index + 1) % (@players.length)
  end

  def take_turn(player)
    puts "your turn " + player.name
    puts "current fragment: " + @fragment
    guess = player.guess
    while !valid_play?(guess)
      player.alert_invalid_guess
      guess = player.guess
    end
     @fragment += guess
  end

  def valid_play?(string)
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    if alphabet.include?(string.downcase)
      new_fragment = @fragment + string
      return true if @dictionary.keys.any? { |key| key[0...new_fragment.length] == new_fragment}
    end
    false
  end
end

player1 = Player.new("Dave")
player2 = Player.new("Jimmy")
player3 = Player.new("AHHH")

ghost = Ghost.new([player1, player2, player3])

ghost.run