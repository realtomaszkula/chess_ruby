require_relative '../chess.rb'

describe Chess do
  let(:game) { Chess.new }

    context '#draw_board' do
      before { game.draw_board }
      it 'shows the board' do
      end
    end

    context '#update_board' do
      before { game.update_board}
      it 'updates the board' do

      end
      after { game.draw_board}
    end



end