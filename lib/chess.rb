require_relative './pieces.rb'
require_relative './player.rb'
require_relative './board.rb'
require_relative './modules/movement.rb'
require_relative './modules/castling.rb'
require_relative './modules/en_passant.rb'
require_relative './modules/pawn_promotion.rb'
require 'yaml'

class Chess
  include Castling
  include EnPassant
  include PawnPromotion

  attr_accessor :plr1, :plr2, :board, :active_player, :opposing_player
  def initialize
    create_players
    create_clear_board
    @active_player = @plr1
    @opposing_player = @plr2
    implement_changes
  end

  def play
    loop do
      temp_save
      player_move
      if @active_player.in_check?
        load_temp
        puts "This move would put you in check, try again!"
        player_move
      end
      implement_changes
      change_turn
    end
  end

  def implement_changes
    collect_all_pieces
    create_clear_board
    update_board
    # draw_board
  end

  def player_move
    input = input_move()
    @selected_position = split_and_convert(input[0])
    @selected_destination = split_and_convert(input[1])
    @selected_figure = @active_player.pieces.find { |piece| piece.position == @selected_position }

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

    en_passant_mechanics
    promote if pawn_promotion
  end

  def input_move
    puts "\n\t\t\t\t:#{@active_player.color}_player, enter your move"
    input = gets.chomp.upcase
    until (input.size == 5             &&
          input[2]     == " "          &&
          input[0].ord.between?(65,72) &&
          input[3].ord.between?(65,72) &&
          input[1].to_i.between?(1,8)  &&
          input[4].to_i.between?(1,8)) || input == 'SAVE' || input == 'CASTLE'
       puts "\t\t\t\tIncorrect, try again"
       input = gets.chomp.upcase
    end

    case input
    when 'SAVE' then save_the_game; input_move
    when 'CASTLE' then castle
    else input = input.split
    end  ## ["A1" "A2"]
  end

  def split_and_convert(input)
    input = input.split("").reverse
    input[0] = input[0].to_i - 1
    input[1] = input[1].ord - 65
    input #[]
  end

  def check_if_in_check
    king = @active_player.pieces.find { |piece| piece.figure == :king }
    all_positions = @opposing_player.pieces.map { |piece| piece.find_possible_moves }.flatten
    @active_player.in_check = true if all_positions.any? { |position| king.position == position }
  end

  def in_check?(plr)
    plr.in_check == true
  end

  def change_turn
    if @active_player == @plr1
      @active_player = @plr2; @opposing_player = @plr1
    else
      @active_player = @plr1; @opposing_player = @plr2
    end
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

  def temp_save
    yaml_string = YAML::dump(self)
    File.open("./temp/save.txt", "w") do |f|
      f.puts yaml_string
    end
  end

  def load_temp
    yaml_string = File.open("./temp/save.txt","r") {|fname| fname.read}
    x = YAML::load(yaml_string)
  end

  def castle
    unless can_castle? then puts "Incorrect! Can't castle!"; input_move; end
    if @can_castle_both_ways
      puts 'Enter:\nKING - to castle kingside\nQUEEN - to castle queenside'
      case input = gets.chomp
      when 'QUEEN'  then @active_player.castle(:queenside)
      when 'KNIGHT' then @active_player.castle(:kingside)
      end
    elsif @can_castle_queenside then @active_player.castle(:queenside)
    elsif @can_castle_kingside then @active_player.castle(:kingside)
    end
  end

end

 # x = Chess.new
 # x.play
