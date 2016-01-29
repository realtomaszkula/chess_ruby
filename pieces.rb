class Piece
  def initialize(color, position)
    @color = color
    @position =  position
  end

  def move
  end

  private




end

class Knight < Piece
  def initialize(color, position)
    super(color, position)
    @figure = :knight
  end

  def movement_pattern

  end

end

class Bishop < Piece
  def initialize(color, position)
    super(color, position)
    @figure = :bishop
  end
end

class Queen < Piece
  def initialize(color, position)
    super(color, position)
    @figure = :queen
  end
end

class King < Piece
  def initialize(color, position)
    super(color, position)
    @figure = :king
    @castling = true
  end
end

class Rook < Piece
  def initialize(color, position)
    super(color, position)
    @figure = :rook
    @castling = true
  end
end

class Pawn < Piece
  def initialize(color, position)
    super(color, position)
    @figure = true
    @first_move = true
  end

  def pawn_promotion
  end

  def en_passant
  end
end

for i in 0..7
  Pawn.new(:white, [1,i])
  Pawn.new(:black, [6,i])
end

  Rook.new(   :white, [0,0])
  Rook.new(   :white, [0,7])
  Bishop.new( :white, [0,6])
  Bishop.new( :white, [0,1])
  Knight.new( :white, [0,5])
  Knight.new( :white, [0,2])
  Queen.new(  :white, [0,3])
  King.new(   :white, [0,4])

  Rook.new(   :black, [7,0])
  Rook.new(   :black, [7,7])
  King.new(   :black, [7,4])
  Queen.new(  :black, [7,3])
  Knight.new( :black, [7,2])
  Knight.new( :black, [7,5])
  Bishop.new( :black, [7,1])
  Bishop.new( :black, [7,6])




