require_relative '../lib/chess.rb'


describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }
  let(:active_player) { game.active_player }
  let(:update) { game.implement_changes }

  describe '#can_castle?' do
    it 'returns false when the game starts' do
      expect(game.can_castle?).to eql false
    end

    context 'on empty board' do
      it 'returns true with just king and rook' do
        active_player.pieces = [ King.new(:white, [0,4]), Rook.new(:white, [0,7], :king) ]
        update
        expect(game.can_castle?).to eql true
      end
      it 'returns false when king moved' do
        king = King.new(:white, [0,4])
        king.instance_variable_set(:@moved, true)
        active_player.pieces  = [ Rook.new(:white, [0,7], :king), king ]
        update
        expect(game.can_castle?).to eql false
      end
      it 'returns false when rook moved' do
        rook = Rook.new(:white, [0,7], :king)
        rook.instance_variable_set(:@moved, true)
        active_player.pieces = [ King.new(:white, [0,4]), rook ]
        update
        expect(game.can_castle?).to eql false
      end
      it 'returns false with piece inbetween' do
        active_player.pieces = [ King.new(:white, [0,4]), Pawn.new(:white, [0,5]), Rook.new(:white, [0,7], :king) ]
        update
        expect(game.can_castle?).to eql false
      end
      it 'returns false when king is in check' do
        active_player.in_check = true
        active_player.pieces = [ King.new(:white, [0,4]), Pawn.new(:white, [0,5]), Rook.new(:white, [0,7], :king) ]
        update
        expect(game.can_castle?).to eql false
      end
    end
  end
end

describe Player do
  describe '#castle' do
  let(:game) { Chess.new }
  let(:player) { game.plr1 }

  context 'when kingside' do
    it do
      king = King.new(:white, [0,4])
      rook = Rook.new(:white, [0,7], :king)
      player.pieces = [ king, rook ]
      expect { player.castle(:king) }.to change{ king.position }.from([0,4]).to([0,6])
    end

    it do
      king = King.new(:white, [0,4])
      rook = Rook.new(:white, [0,7], :king)
      player.pieces = [ king, rook ]
      expect { player.castle(:king) }.to change{ rook.position }.from([0,7]).to([0,5])
    end
  end

  context 'when queenside' do
    it do
      king = King.new(:white, [0,4])
      rook = Rook.new(:white, [0,0], :queen)
      player.pieces = [ king, rook ]
      expect { player.castle(:queen) }.to change{ king.position }.from([0,4]).to([0,2])
    end

    it do
      king = King.new(:white, [0,4])
      rook = Rook.new(:white, [0,0], :queen)
      player.pieces = [ king, rook ]
      expect { player.castle(:queen) }.to change{ rook.position }.from([0,0]).to([0,3])
    end
  end
  end
end
