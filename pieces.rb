# require_relative './pieces.rb'
# require_relative './chess.rb'

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

  def position=(destination)
    @position = destination
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
  end

  def occupied_by_enemy?(a,b)
    @opposing_player.pieces.any? { |piece| piece.position == [a,b] }
  end

  def empty_square?(a,b)
    all_pieces = @active_player.pieces + @opposing_player.pieces
    all_pieces.none? { |piece| piece.position == [a,b] }
  end

  def pawn_promotion
    # case @color
    # when :black
    #   case @input #||= gets.chomp.upcase
    #   when 'QUEEN'  then  puts 'test' ; plr1.pieces << Queen.new(@color, [1,2])
    #   when 'KNIGHT' then plr1.pieces << Knight.new(@color, @position)
    #   when 'ROOK'   then plr1.pieces << Rook.new(@color, @position)
    #   when 'BISHOP' then plr1.pieces << Bishop.new(@color, @position)
    #   else puts 'Incorrect, try again'; pawn_promotion
    #   end
    # when :white
    #   case @input #||= gets.chomp.upcase
    #   when 'QUEEN'  then  puts 'test' ; plr2.pieces << Queen.new(@color, @position)
    #   when 'KNIGHT' then plr2.pieces << Knight.new(@color, @position)
    #   when 'ROOK'   then plr2.pieces << Rook.new(@color, @position)
    #   when 'BISHOP' then plr2.pieces << Bishop.new(@color, @position)
    #   else puts 'Incorrect, try again'; pawn_promotion
    #   end
    # end
  end

  def en_passant
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
      a = x +  1; b = y + -2; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
      a = x +  2; b = y + -1; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
      a = x +  1; b = y +  2; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
      a = x +  2; b = y +  1; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
      a = x + -1; b = y + -2; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
      a = x + -2; b = y + -1; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
      a = x + -1; b = y +  2; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
      a = x + -2; b = y +  1; @possible_moves << [a,b]  if a.between?(0,7) && b.between?(0,7)
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
    x, y = @position[0], @position[1]
    @possible_moves = []

    @possible_moves
  end
end

class Rook < Piece
  attr_reader :color, :figure
  attr_accessor :position, :possible_moves

  def initialize(color, position)
    super(color, position)
    @figure = :rook
    @castling = true
    @unicode =  case @color
                when :white then "\u2656"
                when :black then "\u265C"
                end
  end

  def find_possible_moves
    x, y = @position[0], @position[1]
    @possible_moves = []

    count = 0
    for i in (x+1)..7
      break if @active_player.pieces.any? { |piece| piece.position ==  [i,y] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [i,y] }
      break if count == 2
      @possible_moves << [i,y]
    end

    count = 0
    for i in (x-1).downto(0)
      break if @active_player.pieces.any? { |piece| piece.position ==  [i,y] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [i,y] }
      break if count == 2
      @possible_moves << [i,y]
    end

    count = 0
    for i in (y+1)..7
      break if @active_player.pieces.any? { |piece| piece.position ==  [x,i] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [x,i] }
      break if count == 2
      @possible_moves << [x,i]
    end

    count = 0
    for i in (y-1).downto(0)
      break if @active_player.pieces.any? { |piece| piece.position ==  [x,i] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [x,i] }
      break if count == 2
      @possible_moves << [x,i]
    end
    @possible_moves
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
    x, y = @position[0], @position[1]
    @possible_moves = []

    a = x + 1
    b = y + 1

    count = 0
    for i in 0..7
      break unless (a+i).between?(0,7) && (b+i).between?(0,7)
      break if @active_player.pieces.any? { |piece| piece.position ==  [a+i,b+i] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [a+i,b+i] }
      break if count == 2
      @possible_moves << [a+i,b+i]
    end

    a = x - 1
    b = y + 1

    count = 0
    for i in 0..7
      break unless (a-i).between?(0,7) && (b+i).between?(0,7)
      break if @active_player.pieces.any? { |piece| piece.position ==  [a-i,b+i] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [a-i,b+i] }
      break if count == 2
      @possible_moves << [a-i,b+i]
    end

    a = x + 1
    b = y - 1

    count = 0
    for i in 0..7
      break unless (a+i).between?(0,7) && (b-i).between?(0,7)
      break if @active_player.pieces.any? { |piece| piece.position ==  [a+i,b-i] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [a+i,b-i] }
      break if count == 2
      @possible_moves << [a+i,b-i]
    end

    a = x - 1
    b = y - 1

    count = 0
    for i in 0..7
      break unless (a-i).between?(0,7) && (b-i).between?(0,7)
      break if @active_player.pieces.any? { |piece| piece.position ==  [a-i,b-i] }
      count += 1 if @opposing_player.pieces.any? { |piece| piece.position ==  [a-i,b-i] }
      break if count == 2
      @possible_moves << [a-i,b-i]
    end

    @possible_moves
  end
end

class King < Piece
  attr_reader :color, :figure
  attr_accessor :position, :possible_moves

  def initialize(color, position)
    super(color, position)
    @figure = :king
    @castling = true
    @unicode =  case @color
                when :white then "\u2654"
                when :black then "\u265A"
                end
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


