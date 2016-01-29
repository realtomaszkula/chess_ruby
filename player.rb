require_relative './pieces.rb'

class Player
  attr_reader :name, :color
  attr_accessor :pieces
  def initialize(name, color)
    @name = name
    @color = color
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
