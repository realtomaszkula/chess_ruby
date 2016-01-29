class Piece
  attr_reader :color, :figure
  attr_accessor :position


  def initialize(color, position)
    @color = color
    @position =  position
  end

  def move
    @position = movement_pattern
  end


end

class Knight < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :knight
  end

  def movement_pattern
  end
end

class Bishop < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :bishop
  end
end

class Queen < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :queen
  end
end

class King < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :king
    @castling = true
  end
end

class Rook < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :rook
    @castling = true
  end
end

class Pawn < Piece

  attr_reader :color, :figure
  attr_accessor :position


  def initialize(color, position)
    super(color, position)
    @figure = :pawn
    @moved = false
    @promote_position = promote_position
  end

  def move
    @moved = true
    super
  end

  def promote_position
    x = @position[0]

    case @color
    when :white then return (0..7).collect {|i| [x+6, i]}
    when :black then return (0..7).collect {|i| [x-6, i]}
    end

  end

  def movement_pattern
    x, y = @position[0], @position[1]
    moved ? [x+1, y] : [[x+1, y], [x+2, y]]

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




