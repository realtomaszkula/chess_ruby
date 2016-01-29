require_relative './pieces.rb'
require_relative './player.rb'
require_relative './board.rb'

class Chess
  attr_reader :plr1, :plr2, :board, :all_pieces
  def initialize
    make_players
    make_board
    @all_pieces = @plr1.pieces + @plr2.pieces
    @active_player = @plr1
    # update_board
  end

  def play

  end

  def player_move

    ## mockup for rspec
    input = "00 34"
    input = input.split

    # input = input_move()

    @selected_position = split_and_convert(input[0])
    # @selected_unicode = @board.value[from[0]][from[1]] ## points to unicode representation
    @selected_figure = @active_player.pieces.select { |piece| piece.position == @selected_position }

    p @selected_figure
    # unless @active_player.pieces.include?(@selected_figure)

    to = split_and_convert(input[1])
    @selected_to = @board.value[to[0]][to[1]]

    # puts "from: #{@selected_position}, to: #{@selected_to}"

  end

  def input_move
    puts "Enter your move [ to move from A1 to A2 type: A1 A2 ]"
    input = gets.chomp.downcase
    until input.length == "5"          &&
          input[2]     == " "          &&
          input[0].ord.between?(65,72) &&
          input[3].ord.between?(65,72) &&
          input[1].to_i.between?(1,8)  &&
          input[4].to_i.between?(1,8)
       "Incorrect, try again"
        input = gets.chomp.downcase
    end
    input = input.split ## ["70" "34"]
  end

  def split_and_convert(input)
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




