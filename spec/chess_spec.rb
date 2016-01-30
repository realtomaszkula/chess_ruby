require_relative '../chess.rb'

describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }
  let(:update) {
                  game.collect_all_pieces
                  game.update_board
                  #game.draw_board
                }

    describe Pawn do

      context 'when moving' do
        before do
          @pawn = Pawn.new(:white, [1,1])
        end
          it { expect{ @pawn.position=[2,1] }.to change{@pawn.position}.from([1,1]).to([2,1]) }
          it { expect{ @pawn.position=[2,1] }.to change{@pawn.moved}.from(false).to(true) }
          it 'to another side of the board' do
            expect(@pawn).to receive(:pawn_promotion).with(no_args)
            @pawn.position=[7,1]
          end

      end

      context 'testing if [6,2] can move diagonally to kill [5,1]' do

        before do
          game.plr1.pieces << Pawn.new(:white, [5,1] )
          update
          @killer = game.plr2.pieces.select { |piece| piece.position == [6,2] }.first
          @killer.find_possible_moves(plr1, plr2)
        end

        it 'adds an extra move when possible to kill another piece' do
          expect(@killer.possible_moves).to match_array([[5,1], [4,2], [5,2]])
        end
      end

      context 'testing if [1,1] can move diagonally to kill [2,2]' do
        before do
          game.plr2.pieces << Pawn.new(:black, [2,2] )
          update
          @killer = game.plr1.pieces.select { |piece| piece.position == [1,1] }.first
          @killer.find_possible_moves(plr1, plr2)
        end

        it 'adds an extra move when possible to kill another piece' do
          expect(@killer.possible_moves).to match_array([[2,2], [3,1], [2,1]])
        end
      end

    end






end