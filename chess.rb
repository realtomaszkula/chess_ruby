require_relative './pieces.rb'
require_relative './player.rb'
require_relative './board.rb'

class Chess
  attr_accessor :plr1, :plr2, :board
  def initialize
    create_players
    create_clear_board
    @active_player = @plr1
    @opposing_player = @plr2
    collect_all_pieces
  end

  def play
    player_move
    collect_all_pieces
    create_clear_board
    update_board
  end

  def player_move
    input = input_move()

    @selected_position = split_and_convert(input[0])
    @selected_destination = split_and_convert(input[1])
    @selected_figure = @active_player.pieces.select { |piece| piece.position == @selected_position }.first
    puts "Incorrect, try again"; player_move if @selected_figure == nil

    @selected_figure.receive_environment(@plr1, @plr2)
    @selected_figure.find_possible_moves
    puts "Incorrect, try again"; player_move unless @selected_figure.possible_moves.include?(@selected_destination)

    if @board.empty_field?(@selected_destination)
      @selected_figure.position = @selected_destination
    elsif @board.occupied_by_an_ally?(@selected_destination, @active_player)
      puts "Incorrect, try again"; player_move
    else
      @selected_figure.position = @selected_destination
    end



    collect_all_pieces
    create_clear_board
    update_board

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

  def create_players
    @plr1 = Player.new('Tomasz', :white)
    @plr2 = Player.new('Piotr', :black)
  end

  def collect_all_pieces
    @all_pieces = @plr1.pieces + @plr2.pieces
  end

  def create_clear_board
    @board = Board.new
  end

  def draw_board
    @board.draw
  end

  def update_board
    @board.update(@all_pieces)
  end

end




