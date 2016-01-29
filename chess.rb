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

  end

  def player_move

    ## mockup for rspec
    # input = "70 34"
    # input = input.split

    input = input_move()
    from = convert_to_integer(input[0])
    to = convert_to_integer(input[1])

    @selected_from = @board.value[from[0]][from[1]]
    @selected_to = @board.value[to[0]][to[1]]

    puts "from: #{@selected_from}, to: #{@selected_to}"

  end

  def input_move
    puts "Enter your move [ to move from A1 to A2 type: A1 A2 ]"
    input = gets.chomp.downcase
    until input.length == "5" && input[2] == " " && input[0].ord.between?(65,72) && input[3].ord.between?(65,72)  && input[1].to_i.between?(1,8)  && input[4].to_i.between?(1,8)
       "Incorrect, try again"
    end
    input = input.split ## ["70" "34"]
  end

  def convert_to_integer(input)
    input.split("").collect!(&:to_i)  ## [7,0]
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




