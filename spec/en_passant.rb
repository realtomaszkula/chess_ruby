require_relative '../lib/chess.rb'

describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }

  describe '#mark_enemy_passant' do
  context 'when white plr moves' do
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

  context 'when black plr moves' do
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
end

end