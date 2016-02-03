class Board
  attr_accessor :value
  def initialize
    @value = [
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
    puts "\n\n"
    @value.reverse.each_with_index do |row, i|
      print "\t\t\t #{(i-8).abs}"
      row.each { |x| print "|#{x}" }
      print "|\n"
    end
    letters = ('A'..'H').to_a.join(" ")
    print "\t\t\t   #{letters}\n"
  end

  def update(all_pieces)
    all_pieces.each do |piece|
      x = piece.position[0]
      y = piece.position[1]
      @value[x][y] = "#{piece.unicode}"
    end
  end

  def empty_field?(position)
    x = position[0]
    y = position[1]
    @value[x][y] == " "
  end

  def occupied_by_an_enemy?(destination, opposing_player )
    opposing_player.pieces.any? { |piece| piece.position == destination }
  end

end

