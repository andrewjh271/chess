require './lib/board.rb'

# tests Engine module, which is used by Board class
describe Engine do
  board = Board.new

  describe 'choose_move' do
    context 'depth of 1' do
      
      
      it 'finds mate in 1' do
        board = Board.new
        board.move('e4')
        board.move('e5')

        board.move('Bc4')
        board.move('Bc5')

        board.move('Qh5')
        board.move('Nf6')
        # checkmate sign # not added until move is actually made
        expect(board.choose_move(1)).to eq('Qxf7')
      end
    end

    context 'depth of 3' do
      it 'finds mate in 2' do
        board = Board.new

        board.move('f3')
        board.move('e6')
  
        board.move('Nc3')
        board.move('Bd6')
  
        board.move('b3')
        board.move('Qh4+')
  
        board.move('g3')

        expect(board.choose_move(3)).to eq('Qxg3').or eq('Bxg3')
      end
    end
  end
end