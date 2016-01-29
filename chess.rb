require_relative './pieces.rb'
require_relative './player.rb'
require_relative './board.rb'

class Chess
  attr_reader :plr1, :plr2, :board
  def initialize
    make_players
    make_board
  end

  def play
    @board.draw
  end

  private

  def make_players
    @plr1 = Player.new('Tomasz', :white)
    @plr2 = Player.new('Piotr', :black)
  end

  def make_board
    @board = Board.new
  end

end




