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
    @unicode = case @color
              when :white then "\u2659".encode('utf-8')
              when :black then "\u265F".encode('utf-8')
              end

  end

  def move
    super
    @moved = true
    pawn_promotion if @promote_position.include?(@position)
  end

  private

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
                when :white then "\u2658".encode('utf-8')
                when :black then "\u265E".encode('utf-8')
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
                when :white then "\u2657".encode('utf-8')
                when :black then "\u265D".encode('utf-8')
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
                when :white then "\u2655".encode('utf-8')
                when :black then "\u265B".encode('utf-8')
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
                when :white then "\u2654".encode('utf-8')
                when :black then "\u265A".encode('utf-8')
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
                when :white then "\u2656".encode('utf-8')
                when :black then "\u265C".encode('utf-8')
                end
  end
end






