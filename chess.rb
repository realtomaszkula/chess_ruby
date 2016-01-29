require_relative './pieces.rb'
require_relative './player.rb'

class Chess
  attr_reader :plr1, :plr2
  def initialize
    get_players
  end

  def get_players
    @plr1 = Player.new('Tomasz', :white)
    @plr2 = Player.new('Piotr', :black)
  end

end


