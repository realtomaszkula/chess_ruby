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
    temp_save
    player_move
    if @active_player.in_check?
      load_temp
      puts "This move would put you in check, try again!"
      player_move
    end
    impement_changes
    change_turn
  end

  def temp_save
    def save_the_game
    yaml_string = YAML::dump(self)
    File.open("./temp/save.txt", "w") do |f|
      f.puts yaml_string
    end
  end

  def load_temp
    yaml_string = File.open("./temp/save.txt","r") {|fname| fname.read}
    x = YAML::load(yaml_string)
  end

  def check_if_in_check
    king = @active_player.pieces.find { |piece| piece.figure == :king }
    all_positions = @opposing_player.pieces.map { |piece| piece.find_possible_moves }.flatten
    @active_player.in_check = true if all_positions.any? { |position| king.position == position }
  end

  def in_check?(plr)
    plr.in_check == true
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

    en_passant_mechanics
    promote if pawn_promotion?
  end

  def en_passant_mechanics
    capture_pawn if captured_en_passant?
    clear_own_en_passant_marks
    mark_enemy_passant if en_passant?
  end

  def clear_own_en_passant_marks
    @active_player.pieces.select { |piece| piece.figure == :pawn }.select { |pawn| !pawn.en_passant.empty? }.map! { |pawn| pawn.en_passant = [] }
  end


  def capture_pawn
    case @active_player.color
    when :white then captured_pawn = @opposing_player.pieces.find { |piece| piece.position == [@selected_destination[0] + 1, @selected_destination[1] }
    when :black then captured_pawn = @opposing_player.pieces.find { |piece| piece.position == [@selected_destination[0] + 1, @selected_destination[1] }
    end
    @opposing_player.kill_piece(captured_pawn)
  end

  def captured_en_passant?
    return false if @selected_figure.figure != :pawn
    @selected_destination == @selected_figure.en_passant
  end

  def mark_enemy_passant
    y1 = @selected_destination[1] + 1
    y2 = @selected_destination[1] - 1
    x =  @selected_destination[1]

    pawn1 = @opposing_player.pieces.find { |piece| piece.positon == [x,y1]}
    pawn2 = @opposing_player.pieces.find { |piece| piece.positon == [x,y2]}


    case @opposing_player.color
    when :white
      en_passant_capture_possition = [@selected_destination[0] - 1, @selected_destination[1]]
      pawn1.en_passant << en_passant_capture_possition if pawn1 != nil
      pawn2.en_passant << en_passant_capture_possition if pawn2 != nil
    when :black
      en_passant_capture_possition = [@selected_destination[0] + 1, @selected_destination[1]]
      pawn1.en_passant << en_passant_capture_possition if pawn1 != nil
      pawn2.en_passant << en_passant_capture_possition if pawn2 != nil
    end

  end

  def en_passant?
    @selected_figure.figure == :pawn  && (@selected_destination[1] - @selected_position[1]).abs == 2
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
    unless can_castle? puts "Incorrect! Can't castle!"; input_move

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

  def can_castle?
    check? = @active_player.in_check?
    king_moved? = @active_player.pieces.find { |piece| piece.figure == :king }.moved

    @can_castle_queenside = queenside_space_empty? && !queenside_rook_moved?
    @can_castle_kingside = kingside_space_empty? && !kingside_rook_moved?
    @can_castle_both_ways = @can_castle_queenside && @can_castle_kingside

    check? && !king_moved? && (@can_castle_queenside || @can_castle_kingside)
  end

  def queenside_space_empty?
    case @active_player.color
    when :black
      @board.empty_field?([7,1]) && @board.empty_field?(7,2) && @board.empty_field?(7,3)
    when :white
      @board.empty_field?([0,1]) && @board.empty_field?(0,2) && @board.empty_field?(0,3)
    end
  end

  def kingside_space_empty?
    case @active_player.color
    when :black
      @board.empty_field?([7,5]) && @board.empty_field?(7,6)
    when :white
      @board.empty_field?([0,5]) && @board.empty_field?(0,6)
    end
  end

  def queenside_rook_moved?
    rook = @active_player.find_all { |piece| piece.figure == :rook }.find { |rook| rook.side == :queen }
    rook.moved
  end

  def kingside_rook_moved?
    rook = @active_player.find_all { |piece| piece.figure == :rook }.find { |rook| rook.side == :king }
    rook.moved
  end

end


# x = Chess.new
# x.play
