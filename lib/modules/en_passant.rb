module EnPassant

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
    when :white then captured_pawn = @opposing_player.pieces.find { |piece| piece.position == [@selected_destination[0] + 1, @selected_destination[1]] }
    when :black then captured_pawn = @opposing_player.pieces.find { |piece| piece.position == [@selected_destination[0] + 1, @selected_destination[1]] }
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


end