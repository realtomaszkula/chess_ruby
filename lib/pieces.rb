class Piece
  attr_reader :color, :figure, :unicode
  attr_accessor :position, :possible_moves

  def initialize(color, position)
    @color = color
    @position =  position
    @possible_moves = []
  end

  def receive_environment(active_player, opposing_player)
    @active_player = active_player
    @opposing_player = opposing_player
  end

  def empty_and_in_range?(a,b)
    a.between?(0,7) && b.between?(0,7) && @active_player.pieces.none? { |piece| piece.position == [a,b] }
  end

end

class Pawn < Piece

  attr_reader :color, :figure, :possible_moves, :moved
  attr_accessor :position , :en_passant, :promote


  def initialize(color, position)
    super(color, position)
    @figure = :pawn
    @moved = false
    @promote_position = promote_position
    @promote = false
    @en_passant = []
    @unicode = case @color
              when :white then "\u2659"
              when :black then "\u265F"
              end
  end

  def position=(destination)
    @position = destination
    @moved = true
    @promote = true if @promote_position.include?(@position)
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
    @possible_moves = []

    case @color
    when :white
      @possible_moves << [x+1, y]   if empty_square?(x+1,y)
      @possible_moves << [x+2, y]   unless @moved || !empty_square?(x+1,y) || !empty_square?(x+2,y)
      @possible_moves << [x+1, y+1] if occupied_by_enemy?(x+1, y+1)
      @possible_moves << [x+1, y-1] if occupied_by_enemy?(x+1, y-1)
    when :black
      @possible_moves << [x-1, y]   if empty_square?(x-1,y)
      @possible_moves << [x-2, y]   unless @moved || !empty_square?(x-1,y) || !empty_square?(x-2,y)
      @possible_moves << [x-1, y+1] if occupied_by_enemy?(x-1, y+1)
      @possible_moves << [x-1, y-1] if occupied_by_enemy?(x-1, y-1)
    end
    @possible_moves << @en_passant.first if @en_passant.first != nil
    @possible_moves
  end

  def occupied_by_enemy?(a,b)
    @opposing_player.pieces.any? { |piece| piece.position == [a,b] }
  end

  def empty_square?(a,b)
    all_pieces = @active_player.pieces + @opposing_player.pieces
    all_pieces.none? { |piece| piece.position == [a,b] }
  end

end

class Knight < Piece
  attr_reader :color, :figure
  attr_accessor :position, :possible_moves

  def initialize(color, position)
    super(color, position)
    @figure = :knight
    @unicode =  case @color
                when :white then "\u2658"
                when :black then "\u265E"
                end
  end

  def find_possible_moves
    x, y = @position[0], @position[1]
    @possible_moves = []
      a = x +  1; b = y + -2; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      a = x +  2; b = y + -1; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      a = x +  1; b = y +  2; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      a = x +  2; b = y +  1; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      a = x + -1; b = y + -2; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      a = x + -2; b = y + -1; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      a = x + -1; b = y +  2; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      a = x + -2; b = y +  1; @possible_moves << [a,b]  if empty_and_in_range?(a,b)
      @possible_moves
  end
end

class Rook < Piece
  attr_reader :color, :figure, :moved, :side
  attr_accessor :position, :possible_moves

  def initialize(color, position, side = nil, moved = false)
    super(color, position)
    @figure = :rook
    @moved = moved
    @side = side
    @unicode =  case @color
                when :white then "\u2656"
                when :black then "\u265C"
                end
  end

  def find_possible_moves
    @possible_moves = Rooky::find_possible_moves(@position[0], @position[1], @active_player, @opposing_player)
  end

  def position=(destination)
    @position = destination
    @moved = true
  end
end


class Bishop < Piece
  attr_reader :color, :figure
  attr_accessor :position, :possible_moves

  def initialize(color, position)
    super(color, position)
    @figure = :bishop
    @unicode =  case @color
                when :white then "\u2657"
                when :black then "\u265D"
                end

  end
  def find_possible_moves
    @possible_moves = Bishopy::find_possible_moves(@position[0], @position[1], @active_player, @opposing_player)
  end
end

class King < Piece
  attr_reader :color, :figure, :moved
  attr_accessor :position, :possible_moves

  def initialize(color, position)
    super(color, position)
    @figure = :king
    @moved = false
    @unicode =  case @color
                when :white then "\u2654"
                when :black then "\u265A"
                end
  end

  def position=(destination)
    @position = destination
    @moved = true
  end

  def find_possible_moves
    x, y = @position[0], @position[1]
    @possible_moves = []

    a = x + 1; b = y    ; @possible_moves << [a,b] if empty_and_in_range?(a,b)
    a = x + 1; b = y + 1; @possible_moves << [a,b] if empty_and_in_range?(a,b)
    a = x + 1; b = y - 1; @possible_moves << [a,b] if empty_and_in_range?(a,b)
    a = x - 1; b = y    ; @possible_moves << [a,b] if empty_and_in_range?(a,b)
    a = x - 1; b = y + 1; @possible_moves << [a,b] if empty_and_in_range?(a,b)
    a = x - 1; b = y - 1; @possible_moves << [a,b] if empty_and_in_range?(a,b)
    a = x    ; b = y - 1; @possible_moves << [a,b] if empty_and_in_range?(a,b)
    a = x    ; b = y + 1; @possible_moves << [a,b] if empty_and_in_range?(a,b)

    @possible_moves
  end
end

class Queen < Piece
  attr_reader :color, :figure
  attr_accessor :position, :possible_moves

  def initialize(color, position)
    super(color, position)
    @figure = :queen
    @unicode =  case @color
                when :white then "\u2655"
                when :black then "\u265B"
                end
  end

  def find_possible_moves
      rook_possible_moves = Rooky::find_possible_moves(@position[0], @position[1], @active_player, @opposing_player)
      bishop_possible_moves = Bishopy::find_possible_moves(@position[0], @position[1], @active_player, @opposing_player)
      @possible_moves = rook_possible_moves + bishop_possible_moves
  end
end


