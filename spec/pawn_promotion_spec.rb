require_relative '../lib/chess.rb'

describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }

  describe 'Player#kill_piece' do
    it 'removes a piece' do
      expect{ plr1.kill_piece([0,0]) }.to change{ plr1.pieces.size }.from(16).to(15)

    end
  end

  describe 'Player#promote_to' do
    before do
      plr1.pieces = []
      plr2.pieces = []
      @pawn = Pawn.new(:white, [7,0])
      @pawn.promote = true
      plr1.pieces << @pawn
    end

    it 'removes the pawn' do
      plr1.promote_to(:queen)
      expect(plr1.pieces).not_to include(a_kind_of(Pawn))
    end

    it 'creates the queen' do
      plr1.promote_to(:queen)
      expect(plr1.pieces).not_to include(a_kind_of(Pawn))
      expect(plr1.pieces).to include(a_kind_of(Queen))
    end

    it 'creates the rook' do
      plr1.promote_to(:rook)
      expect(plr1.pieces).not_to include(a_kind_of(Pawn))
      expect(plr1.pieces).to include(a_kind_of(Rook))
    end


    it 'creates the bishop' do
      plr1.promote_to(:bishop)
      expect(plr1.pieces).not_to include(a_kind_of(Pawn))
      expect(plr1.pieces).to include(a_kind_of(Bishop))
    end


    it 'creates the knight' do
      plr1.promote_to(:knight)
      expect(plr1.pieces).not_to include(a_kind_of(Pawn))
      expect(plr1.pieces).to include(a_kind_of(Knight))
    end


  end
end