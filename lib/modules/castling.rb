module Castling
  def can_castle?
    check = @active_player.in_check?
    king_moved = @active_player.pieces.find { |piece| piece.figure == :king }.moved

    @can_castle_queenside = queenside_space_empty? && !queenside_rook_moved?
    @can_castle_kingside = kingside_space_empty? && !kingside_rook_moved?
    @can_castle_both_ways = @can_castle_queenside && @can_castle_kingside

    check && !king_moved && (@can_castle_queenside || @can_castle_kingside)
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

  def castle
    unless can_castle? then puts "Incorrect! Can't castle!"; input_move end
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