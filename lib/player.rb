class Player
  attr_reader :name, :color
  attr_accessor :pieces, :in_check
  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
    @in_check = false
    get_pieces
  end

  def show
    @pieces.each {|piece| puts piece.inspect }
  end

  def in_check?
    @in_check == true
  end

  def kill_piece(position)
    @pieces.select{ |piece| piece = piece unless piece.position == position }.map! { |piece| piece = piece }
  end

  def promote_to(figure)
    @promoted_pawn = @pieces.select { |piece| piece.figure == :pawn }.find { |pawn| pawn.promote == true }
    position = @promoted_pawn.position
    kill_piece(position)

    case figure
    when :queen   then Queen.new(@color, position)
    when :rook    then Rook.new(@color, position)
    when :knight  then Knight.new(@color, position)
    when :bishop  then Bishop.new(@color,position)
    end
  end

  def castle(side)
    king = @pieces.find { |piece| piece.figure == :king }
    king_index = @pieces.index(king)

    rook = @pieces.select { |piece| piece.figure == :rook }.find { |rook| rook.side == side }
    rook_index = @pieces.index(rook)


    case side
    when :king
      king.position[1] += 2
      rook.position[1] -= 2
    when :queen
      king.position[1] -= 2
      rook.position[1] += 2
    end

    @pieces[king_index] = king
    @pieces[rook_index] = rook
  end

  def get_pieces
    case color
      when :white
        for i in 0..7
          @pieces << Pawn.new(:white, [1,i])
        end
          @pieces << Rook.new(   :white, [0,0], :queen)
          @pieces << Rook.new(   :white, [0,7], :king)
          @pieces << Bishop.new( :white, [0,6])
          @pieces << Bishop.new( :white, [0,1])
          @pieces << Knight.new( :white, [0,5])
          @pieces << Knight.new( :white, [0,2])
          @pieces << Queen.new(  :white, [0,3])
          @pieces << King.new(   :white, [0,4])
      when :black
        for i in 0..7
          @pieces << Pawn.new(:black, [6,i])
        end
          @pieces << Rook.new(   :black, [7,0], :queen)
          @pieces << Rook.new(   :black, [7,7], :king)
          @pieces << King.new(   :black, [7,4])
          @pieces << Queen.new(  :black, [7,3])
          @pieces << Knight.new( :black, [7,2])
          @pieces << Knight.new( :black, [7,5])
          @pieces << Bishop.new( :black, [7,1])
          @pieces << Bishop.new( :black, [7,6])
    end
  end
end


