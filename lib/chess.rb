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
  end

  def play
    loop do
      implement_changes
      temp_save
      loop do
        draw_board
        correct_move = player_move
        break if correct_move
      end
      if check_if_in_check
        puts "You are in check"
        load_temp
        next
      end
      change_turn
    end
  end

  def implement_changes
    collect_all_pieces
    create_clear_board
    update_board
    draw_board
  end

  def player_move
    @active_player.castled = false
    input = input_move()
    return true if @active_player.castled == true
    @selected_position = split_and_convert(input[0])
    @selected_destination = split_and_convert(input[1])
    @selected_figure = @active_player.pieces.find { |piece| piece.position == @selected_position }

   return false if @selected_figure == nil

    @selected_figure.receive_environment(@active_player, @opposing_player)
    @selected_figure.find_possible_moves

    unless @selected_figure.possible_moves.include?(@selected_destination)
      show_moves(@selected_figure.possible_moves)
      return false
    end

    if @board.occupied_by_an_enemy?(@selected_destination, @opposing_player)
      @selected_figure.position = @selected_destination
      @opposing_player.kill_piece(@selected_destination)
    else
      @selected_figure.position = @selected_destination
    end

    en_passant_mechanics
    promote if pawn_promotion
    true
  end

  def input_move
    return if @active_player.castled == true
    print "\n\t\t\t\t:#{@active_player.color}_player, enter your move\n\n\t\t\t\t"
    input = gets.chomp.upcase
    until (input.size == 5             &&
          input[2]     == " "          &&
          input[0].ord.between?(65,72) &&
          input[3].ord.between?(65,72) &&
          input[1].to_i.between?(1,8)  &&
          input[4].to_i.between?(1,8)) || input == 'SAVE' || input == 'CASTLE' || input == 'LOAD' || input == 'EXIT'
        puts "\e[H\e[2J";  draw_board
        print "\n\t\t\t\tIncorrect, try again\n\n\t\t\t\t"
        input = gets.chomp.upcase
    end

    case input
    when 'SAVE' then save_the_game; input_move ## need to rework this
    when 'CASTLE' then castle; input_move
    when 'LOAD' then load_the_game
    when 'EXIT' then Kernel.exit
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
    @opposing_player.pieces.each { |piece| piece.receive_environment(@opposing_player, @active_player)  }
    all_positions =  @opposing_player.pieces.map { |piece| piece.find_possible_moves }.flatten(1)
    @active_player.in_check = all_positions.any? { |position| king.position == position } ? true : false
    @active_player.in_check?
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
    puts "\e[H\e[2J";  draw_board
    print "\n\t\t\t\t*  Game saved!  *\n\t\t\t"
  end

  def load_the_game
    yaml_string = File.open("./saves/save.txt","r") {|fname| fname.read}
    game = YAML::load(yaml_string)
    game.play
  end

  def temp_save
    yaml_string = YAML::dump(self)
    File.open("./temp/save.txt", "w") do |f|
      f.puts yaml_string
    end
  end

  def load_temp
    yaml_string = File.open("./temp/save.txt","r") {|fname| fname.read}
    game = YAML::load(yaml_string)
    game.play
  end

  def show_moves(moves)
    print "\t\t\t\t Incorrect - possible moves for this piece:\n\t\t\t\t"
    moves.each do |position|
      print "#{(position[1]+65).chr}#{position[0]+1} "
    end
  end

  def castle
    unless can_castle? then puts "\t\t\t\tIncorrect! Can't castle!"; return; end
    if @can_castle_both_ways
      puts "Enter:\nKING - to castle kingside\nQUEEN - to castle queenside"
      case input = gets.chomp.upcase
      when 'QUEEN'  then @active_player.castle(:queen)
      when 'KING' then @active_player.castle(:king)
      end
    elsif @can_castle_queenside then @active_player.castle(:queen)
    elsif @can_castle_kingside then @active_player.castle(:king)
    end
    @active_player.castled = true
  end

end

