require_relative '../lib/chess.rb'

describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }

  describe '#mark_enemy_passant' do
  context 'when white player moves' do
    before do
      game.instance_variable_set(:@selected_destination, [3,0])
      plr2.pieces = []
      plr1.pieces << Pawn.new(:white, [3,0])
      plr2.pieces << Pawn.new(:black, [3,1])
    end
   it {
    pawn = plr2.pieces.find { |piece| piece.position == [3,1] }
    expect { game.mark_enemy_passant }.to change { pawn.en_passant }.from([]).to([[2,0]])
    }
  end

  context 'when black player moves' do
    before do
      game.instance_variable_set(:@selected_destination, [5,0])
      game.instance_variable_set(:@active_player, plr2)
      game.instance_variable_set(:@opposing_player, plr1)
      plr1.pieces = []
      plr2.pieces << Pawn.new(:black, [5,0])
      plr1.pieces << Pawn.new(:white, [5,1])
    end
   it {
    pawn = plr1.pieces.find { |piece| piece.position == [5,1] }
    expect { game.mark_enemy_passant }.to change { pawn.en_passant }.from([]).to([[6,0]])
    }
  end

  describe '#en_passant?' do
    context 'when white player moves' do
      before do
        @pawn = Pawn.new(:white, [1,0])
        game.instance_variable_set(:@selected_position, [1,0])
        game.instance_variable_set(:@selected_destination, [3,0])
        game.instance_variable_set(:@selected_figure, @pawn)
      end
      it 'returns false when moving two steps forward' do
        expect(game.en_passant?).to eql true
      end
    end
    context 'when black player moves' do
      before do
        @pawn = Pawn.new(:black, [6,0])
        game.instance_variable_set(:@selected_position, [6,0])
        game.instance_variable_set(:@selected_destination, [4,0])
        game.instance_variable_set(:@selected_figure, @pawn)
      end
      it 'returns false when moving two steps forward' do
        expect(game.en_passant?).to eql true
      end
    end
  end

  describe '#captured_en_passant?' do
    it 'returns false when moving non pawn figure' do
        queen = Queen.new(:white, [1,0])
        game.instance_variable_set(:@selected_figure, queen)
        expect(game.captured_en_passant?).to eql false
    end
    it 'returns true when moving to en_passant position' do
        pawn = Pawn.new(:white, [1,0])
        pawn.en_passant = [3,0]
        game.instance_variable_set(:@selected_figure, pawn)
        game.instance_variable_set(:@selected_destination, [3,0])
        expect(game.captured_en_passant?).to eql true
    end
  end

  describe '#capture_pawn' do
    before do
      plr1.pieces = []
      plr2.pieces = []
    end
    it "white player captures black pawn" do
      plr1.pieces << Pawn.new(:white, [5,0])
      plr2.pieces << Pawn.new(:black, [4,0])
      game.instance_variable_set(:@selected_destination, [5,0])
      expect { game.capture_pawn }.to change{ plr2.pieces.size }.from(1).to(0)
    end

    it "black player captures white pawn" do
      game.instance_variable_set(:@active_player, plr2)
      game.instance_variable_set(:@opposing_player, plr1)
      plr2.pieces << Pawn.new(:black, [2,0])
      plr1.pieces << Pawn.new(:white, [3,0])
      game.instance_variable_set(:@selected_destination, [2,0])
      expect { game.capture_pawn }.to change{ plr1.pieces.size }.from(1).to(0)
    end
  end
end

end