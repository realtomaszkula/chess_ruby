require_relative '../chess.rb'

describe Chess do
  let(:game) { Chess.new }
  let(:plr1) { game.plr1 }
  let(:plr2) { game.plr2 }
  let(:update) {
                  game.collect_all_pieces
                  game.update_board
                  # game.draw_board
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
          plr1.pieces << Pawn.new(:white, [5,1] )
          update
          @killer = plr2.pieces.select { |piece| piece.position == [6,2] }.first
          @killer.receive_environment(plr2, plr1)
          @killer.find_possible_moves
        end

        it 'adds an extra move when possible to kill another piece' do
          expect(@killer.possible_moves).to match_array([[5,1], [4,2], [5,2]])
        end
      end

      context 'testing if [1,1] can move diagonally to kill [2,2]' do
        before do
          plr2.pieces << Pawn.new(:black, [2,2] )
          update
          @killer = plr1.pieces.select { |piece| piece.position == [1,1] }.first
          @killer.receive_environment(plr1, plr2)
          @killer.find_possible_moves
        end

        it 'adds an extra move when possible to kill another piece' do
          expect(@killer.possible_moves).to match_array([[2,2], [3,1], [2,1]])
        end
      end
    end

    describe Knight do
      context 'when moving' do
          it do
            knight = Knight.new(:white, [4,4])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(8)
          end
          it do
            knight = Knight.new(:white, [0,0])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it do
            knight = Knight.new(:white, [7,7])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it do
            knight = Knight.new(:white, [0,7])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it do
            knight = Knight.new(:white, [7,0])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(2)
          end
          it do
            knight = Knight.new(:white, [0,4])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it do
            knight = Knight.new(:white, [0,4])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it do
            knight = Knight.new(:white, [7,4])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end
          it do
            knight = Knight.new(:white, [7,4])
            expect{ knight.find_possible_moves }.to change{ knight.possible_moves.size }.from(0).to(4)
          end

      end
    end

    describe Rook do
     context 'when moving on empty board' do
        before do
          plr1.pieces = []
          plr2.pieces = []
        end
          it do
            rook = Rook.new(:white, [0,0])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [7,7])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [0,7])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [7,0])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [0,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [4,0])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [7,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
          it do
            rook = Rook.new(:white, [4,7])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(14)
          end
        end

        context 'when finding possible moves, reacts to the presence of ally pieces' do
          it 'down' do
            plr2.pieces = []
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 3 up, 7 left+right, 2 down

          end

          it 'up' do
            plr1.pieces = []
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr2, plr1)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 2 up, 7 left+right, 3 down
          end

          it 'left' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [4,3])
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(10) # 3 up, 4 down, 0 left, 2 right
          end

          it 'right' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [4,5])
            rook = Rook.new(:white, [4,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(11) # 3 up, 4 down, 4 left, 0 right
          end
        end

        context 'when finding possible moves, reacts to the presence of enemy pieces' do
          before do
            plr1.pieces = []
            plr2.pieces = []
          end
          it 'down' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [4,3]) << Pawn.new(:black, [4,2])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(11) # 3 up, 7 left+right, 1 down
          end

          it 'up' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [4,5]) << Pawn.new(:black, [4,6])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 1 up, 7 left+right, 4 down
          end

          it 'left' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [2,4]) << Pawn.new(:black, [3,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(11) #  7 up and down, 1 left, 3 right
          end

          it 'right' do
            plr1.pieces <<  rook = Rook.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [5,4]) << Pawn.new(:black, [6,4])
            rook.receive_environment(plr1, plr2)
            expect{ rook.find_possible_moves }.to change{ rook.possible_moves.size }.from(0).to(12) # 7 up and down, 4 left, 1 right
          end
        end
    end

    describe Bishop do
      context 'when moving on empty board' do
        before do
          plr1.pieces = []
          plr2.pieces = []
        end

          it do
            bishop = Bishop.new(:white, [0,0])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [7,7])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [0,7])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [7,0])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [0,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [4,0])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [7,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
          it do
            bishop = Bishop.new(:white, [4,7])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(7)
          end
        end

        xcontext 'when finding possible moves, reacts to the presence of ally pieces' do
          it 'down' do
            plr2.pieces = []
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(6)

          end

          it 'up' do
            plr1.pieces = []
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr2, plr1)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(4)
          end

          it 'left-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,3])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(9)
          end

          it 'right-down' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [3,5])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(9)
          end
          it 'left-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,3])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(9)
          end
          it 'right-up' do
            plr2.pieces = []
            plr1.pieces = []
            plr1.pieces << Pawn.new(:white, [5,5])
            bishop = Bishop.new(:white, [4,4])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(9)
          end
        end

        xcontext 'when finding possible moves, reacts to the presence of enemy pieces' do
          before do
            plr1.pieces = []
            plr2.pieces = []
          end
          it 'left-down' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,3]) << Pawn.new(:black, [2,2])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(10)
          end

          it 'left-up' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,5]) << Pawn.new(:black, [2,6])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(11)
          end

          it 'right-up' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [5,5]) << Pawn.new(:black, [6,6])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(11)
          end

          it 'right-down' do
            plr1.pieces <<  bishop = Bishop.new(:white, [4,4])
            plr2.pieces << Pawn.new(:black, [3,5]) << Pawn.new(:black, [2,6])
            bishop.receive_environment(plr1, plr2)
            expect{ bishop.find_possible_moves }.to change{ bishop.possible_moves.size }.from(0).to(11)
          end
        end
    end
end