require_relative './pieces.rb'
require_relative './player.rb'
require_relative './board.rb'
require 'colorize'

class Chess
  attr_reader :plr1, :plr2, :board, :all_pieces
  def initialize
    make_players
    make_board
    @all_pieces = plr1.pieces + plr2.pieces
    # update_board
  end

  def play
    draw_board
  end



  def make_players
    @plr1 = Player.new('Tomasz', :white)
    @plr2 = Player.new('Piotr', :black)
  end

  def make_board
    @board = Board.new
  end

  def draw_board
    @board.draw
  end

  def update_board
    @board.update(@all_pieces)
  end

end




