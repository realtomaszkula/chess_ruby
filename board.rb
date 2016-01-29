class Board
  def initialize
    @board = [
          Array.new(8, " "),
          Array.new(8, " "),
          Array.new(8, " "),
          Array.new(8, " "),
          Array.new(8, " "),
          Array.new(8, " "),
          Array.new(8, " "),
          Array.new(8, " ")
        ]
  end

  def draw
    @board.reverse.each_with_index do |row, i|
      print "\t\t\t\t #{(i-8).abs}"
      row.each { |x| print "|#{x}" }
      print "|\n"
    end
    letters = ('A'..'H').to_a.join(" ")
    print "\t\t\t\t   #{letters}\n"
  end

  def update(all_pieces)
    all_pieces.each do |piece|
      x = piece.position[0]
      y = piece.position[1]
      @board[x][y] = "#{piece.unicode}"
    end
  end

end

