# require_relative './pieces.rb'
# require_relative './chess.rb'

class Piece
  attr_reader :color, :figure, :unicode
  attr_accessor :position

  def initialize(color, position)
    @color = color
    @position =  position
  end

  def move
    @position = possible_moves.first
    p @position
  end

end

class Pawn < Piece

  attr_reader :color, :figure, :possible_moves
  attr_accessor :position


  def initialize(color, position)
    super(color, position)
    @figure = :pawn
    @moved = false
    @promote_position = promote_position
    @unicode = case @color
              when :white then "\u2659"
              when :black then "\u265F"
              end

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

  def find_possible_moves
    x, y = @position[0], @position[1]
    @possible_moves = @moved ? [[x+1, y]] : [[x+1, y], [x+2, y]]
  end


  def pawn_promotion
    puts "Time to promote! [QUEEN, KNIGHT, ROOK, BISHOP]"

    case @color
    when :black
      case input = gets.chomp.upcase
      when 'QUEEN'  then @plr1.pieces << Queen.new(@color, @position)
      when 'KNIGHT' then @plr1.pieces << Knight.new(@color, @position)
      when 'ROOK'   then @plr1.pieces << Rook.new(@color, @position)
      when 'BISHOP' then @plr1.pieces << Bishop.new(@color, @position)
      else puts 'Incorrect, try again'; pawn_promotion
      end
    when :white
      case input = gets.chomp.upcase
      when 'QUEEN'  then @plr2.pieces << Queen.new(@color, @position)
      when 'KNIGHT' then @plr2.pieces << Knight.new(@color, @position)
      when 'ROOK'   then @plr2.pieces << Rook.new(@color, @position)
      when 'BISHOP' then @plr2.pieces << Bishop.new(@color, @position)
      else puts 'Incorrect, try again'; pawn_promotion
      end
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
    @unicode =  case @color
                when :white then "\u2658"
                when :black then "\u265E"
                end
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
    @unicode =  case @color
                when :white then "\u2657"
                when :black then "\u265D"
                end
  end
end

class Queen < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :queen
    @unicode =  case @color
                when :white then "\u2655"
                when :black then "\u265B"
                end
  end
end

class King < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :king
    @castling = true
    @unicode =  case @color
                when :white then "\u2654"
                when :black then "\u265A"
                end
  end
end

class Rook < Piece
  attr_reader :color, :figure
  attr_accessor :position

  def initialize(color, position)
    super(color, position)
    @figure = :rook
    @castling = true
    @unicode =  case @color
                when :white then "\u2656"
                when :black then "\u265C"
                end
  end
end






