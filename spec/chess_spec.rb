require_relative '../chess.rb'

describe Chess do
  let(:game) { Chess.new }

    xdescribe '#draw_board' do
      before { game.draw_board }
      it 'shows the board' do
      end
    end

    xdescribe '#update_board' do
      before { game.update_board}
      it 'updates the board' do

      end
      after { game.draw_board}
    end

    describe '#player_move' do
      before do
        game.update_board
        game.draw_board

      end
      it 'accepts input' do
        game.player_move
      end
      after { game.draw_board }
    end





end