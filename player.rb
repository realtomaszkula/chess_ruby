# require_relative './pieces.rb'
# require_relative './chess.rb'

class Player
  attr_reader :name, :color
  attr_accessor :pieces
  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
    get_pieces
  end

  def show
    @pieces.each {|piece| puts piece.inspect }
  end

  def kill_piece(position)
    @pieces.select{ |piece| piece = piece unless piece.position == position }.map! { |piece| piece = piece }
  end

  def promote_to(figure)
    @promoted_pawn = @pieces.select { |piece| piece.figure == :pawn }.select { |pawn| pawn.promote == true }.first
    position = @promoted_pawn.position
    kill_piece(position)

    case figure
    when :queen   then Queen.new(@color, position)
    when :rook    then Rook.new(@color, position)
    when :knight  then Knight.new(@color, position)
    when :bishop  then Bishop.new(@color,position)
    end


  end

  def get_pieces
    case color
      when :white
        for i in 0..7
          @pieces << Pawn.new(:white, [1,i])
        end
          @pieces << Rook.new(   :white, [0,0])
          @pieces << Rook.new(   :white, [0,7])
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
          @pieces << Rook.new(   :black, [7,0])
          @pieces << Rook.new(   :black, [7,7])
          @pieces << King.new(   :black, [7,4])
          @pieces << Queen.new(  :black, [7,3])
          @pieces << Knight.new( :black, [7,2])
          @pieces << Knight.new( :black, [7,5])
          @pieces << Bishop.new( :black, [7,1])
          @pieces << Bishop.new( :black, [7,6])
      end
    end
end

