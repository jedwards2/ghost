class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess
    puts "input a single letter"
    input = gets.chomp
  end

  def alert_invalid_guess
    puts "invalid guess " + @name  + ", try again"
  end
end