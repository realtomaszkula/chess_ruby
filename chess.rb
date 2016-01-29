require_relative = './pieces.rb'

class Chess

  def initialize

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