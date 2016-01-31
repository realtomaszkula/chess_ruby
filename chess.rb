require_relative './pieces.rb'
require_relative './player.rb'
require_relative './board.rb'
require 'yaml'

class Chess
  attr_accessor :plr1, :plr2, :board
  def initialize
    create_players
    create_clear_board
    @active_player = @plr1
    @opposing_player = @plr2
    implement_changes
  end

  def play
    player_move
    impement_changes
    change_turn
  end

  def player_move
    input = input_move()
    @selected_position = split_and_convert(input[0])
    @selected_destination = split_and_convert(input[1])
    @selected_figure = @active_player.pieces.select { |piece| piece.position == @selected_position }.first

    if @selected_figure == nil
      puts "Incorrect, try again (can only select your own figures)"
      player_move
    end

    @selected_figure.receive_environment(@active_player, @opposing_player)
    @selected_figure.find_possible_moves

    unless @selected_figure.possible_moves.include?(@selected_destination)
      puts "Incorrect, try again (movement outside of possible moves for this figure)"
      player_move
    end

    if @board.occupied_by_an_enemy?(@selected_destination, @opposing_player)
      @selected_figure.position = @selected_destination
      @opposing_player.kill_piece(@selected_destination)
    else
      @selected_figure.position = @selected_destination
    end
    promote if pawn_promotion?
  end

  def promote
      puts 'Promote your peasant, what piece do you want?'
      case input = gets.chomp
      when 'QUEEN'  then @active_player.promote_to(:queen)
      when 'KNIGHT' then @active_player.promote_to(:knight)
      when 'ROOK'   then @active_player.promote_to(:rook)
      when 'BISHOP' then @active_player.promote_to(:bishop)
      else puts 'Incorrect, try again'; input_promotion
      end
  end

  def input_move
    puts "Enter your move [ to move from A1 to A2 type: A1 A2 ]"
    input = gets.chomp.upcase
    until (input.size == 5             &&
          input[2]     == " "          &&
          input[0].ord.between?(65,72) &&
          input[3].ord.between?(65,72) &&
          input[1].to_i.between?(1,8)  &&
          input[4].to_i.between?(1,8)) || input == 'SAVE' || input == 'CASTLE'
       puts "Incorrect, try agaiaan"
       input = gets.chomp.upcase
    end

    case input
    when 'SAVE' then save_the_game; input_move
    when 'CASTLE' then castle;
    else input = input.split
    end  ## ["A1" "A2"]
  end

  def split_and_convert(input)
    input = input.split("").reverse
    input[0] = input[0].to_i - 1
    input[1] = input[1].ord - 65
    input #[]
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

  def update_board
    @board.update(@all_pieces)
  end

  def draw_board
    @board.draw
  end

  def change_turn
    if @active_player = @plr1
      @active_player = @plr2; @opposing_player = @plr1
    else
      @active_player = @plr1; @opposing_player = @plr2
    end
  end

  def save_the_game
    yaml_string = YAML::dump(self)
    File.open("./saves/save.txt", "w") do |f|
      f.puts yaml_string
    end
    print "\n\t\t\t*  Game saved!  *\n\t\t\t"
  end

  def load_the_game
    yaml_string = File.open("./saves/save.txt","r") {|fname| fname.read}
    x = YAML::load(yaml_string)
  end

  def implement_changes
    collect_all_pieces
    create_clear_board
    update_board
    # draw_board
  end

  def pawn_promotion
    @active_player.pieces.select { |piece| piece.figure == :pawn }.any? { |pawn| pawn.promote == true }
  end

  def castle
  end

end


# x = Chess.new
# x.play
