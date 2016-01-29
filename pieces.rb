class Piece

  def initialize(color)
    @color = color
    @position =  set_position
  end

end

class Knight < Piece

  def initialize(color)
    super(color)
    @figure = :knight
  end

  def set_position

  end

end

class Bishop < Piece
  def initialize(color)
    super(color)
    @figure = :bishop
  end

end

class Queen < Piece
  def initialize(color)
    super(color)
    @figure = :queen
  end

end

class King < Piece
  def initialize(color)
    super(color)
    @figure = :king
    @castling = true
  end

  def set_position

  end

end

class Rook < Piece
  def initialize(color)
    super(color)
    @figure = :rook
    @castling = true
  end
end

class Pawn < Piece
  def initialize(color)
    super(color)
    @figure = true
    @first_move = true
  end

  def pawn_promotion

  end

  def en_passant
  end
end

