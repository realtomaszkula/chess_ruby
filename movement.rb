module Bishopy
 def self.find_possible_moves(position_0, position_1, active_player, opposing_player)
    x, y = position_0, position_1
    @possible_moves = []

    a = x + 1
    b = y + 1

    for i in 0..7
      break unless (a+i).between?(0,7) && (b+i).between?(0,7)
      break if active_player.pieces.any? { |piece| piece.position ==  [a+i,b+i] }
      @possible_moves << [a+i,b+i]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [a+i,b+i] }
    end

    a = x - 1
    b = y + 1

    for i in 0..7
      break unless (a-i).between?(0,7) && (b+i).between?(0,7)
      break if active_player.pieces.any? { |piece| piece.position ==  [a-i,b+i] }
      @possible_moves << [a-i,b+i]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [a-i,b+i] }
    end

    a = x + 1
    b = y - 1

    for i in 0..7
      break unless (a+i).between?(0,7) && (b-i).between?(0,7)
      break if active_player.pieces.any? { |piece| piece.position ==  [a+i,b-i] }
      @possible_moves << [a+i,b-i]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [a+i,b-i] }
    end

    a = x - 1
    b = y - 1

    for i in 0..7
      break unless (a-i).between?(0,7) && (b-i).between?(0,7)
      break if active_player.pieces.any? { |piece| piece.position ==  [a-i,b-i] }
      @possible_moves << [a-i,b-i]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [a-i,b-i] }
    end

    @possible_moves
  end
end

module Rooky
  def self.find_possible_moves(position_0, position_1, active_player, opposing_player)
    x, y = position_0, position_1
    @possible_moves = []


    for i in (x+1)..7
      break if active_player.pieces.any? { |piece| piece.position ==  [i,y] }
      @possible_moves << [i,y]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [i,y] }
    end

    for i in (x-1).downto(0)
      break if active_player.pieces.any? { |piece| piece.position ==  [i,y] }
      @possible_moves << [i,y]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [i,y] }
    end

    for i in (y+1)..7
      break if active_player.pieces.any? { |piece| piece.position ==  [x,i] }
      @possible_moves << [x,i]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [x,i] }
    end

    for i in (y-1).downto(0)
      break if active_player.pieces.any? { |piece| piece.position ==  [x,i] }
      @possible_moves << [x,i]
      break if opposing_player.pieces.any? { |piece| piece.position ==  [x,i] }
    end
    @possible_moves
  end
end