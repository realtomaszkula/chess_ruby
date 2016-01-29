class Piece
  attr_reader :color, :figure
  attr_accessor :position


  def initialize(color, position)
    @color = color
    @position =  position
  end

  def move
    @position = possibe_moves.first
    p @position
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
    super
    @moved = true
    pawn_promotion if @promote_position.include?(@position)
  end

  def promote_position
    x = @position[0]

    case @color
    when :white then return (0..7).collect {|i| [x+6, i]}
    when :black then return (0..7).collect {|i| [x-6, i]}
    end

  end

  def possibe_moves
    x, y = @position[0], @position[1]
    @moved ? [[x+1, y]] : [[x+1, y], [x+2, y]]
  end


  def pawn_promotion
    puts "Time to promote! [QUEEN, KNIGHT, ROOK, BISHOP]"
    case input = gets.chomp.upcase
    when 'QUEEN'  then Queen.new(@color, @position)
    when 'KNIGHT' then Knight.new(@color, @position)
    when 'ROOK'   then Rook.new(@color, @position)
    when 'BISHOP' then Bishop.new(@color, @position)
    else puts 'Incorrect, try again'; pawn_promotion
    end
  end

  def en_passant
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








