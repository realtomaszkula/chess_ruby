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
      xcontext 'typical behavior' do
        before do
          game.update_board
          game.draw_board

        end
        it 'accepts input' do
          game.player_move
        end
        after { game.draw_board }
      end

      context 'testing if [6,2] can move diagonally to kill [5,1]' do
        before do
          game.plr1.pieces << Pawn.new(:white, [5,1] )
          game.collect_all_pieces
          game.update_board
          game.draw_board
          @plr1 = game.plr1
          @plr2 = game.plr2
          @killer = game.plr2.pieces.select { |piece| piece.position == [6,2] }.first
          @killer.find_possible_moves(@plr1, @plr2)
        end

        it 'test' do
          expect(@killer.possible_moves).to eql [[4,1], [5,1], [5,2]]
        end
      end

    end





end