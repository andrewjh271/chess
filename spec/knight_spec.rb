require './lib/knight.rb'
require './lib/board.rb'

describe Knight do
  describe '.moves' do

    attr_reader :board

    before do
      # @board = double(:board)
      # allow(board).to receive(:MAX).and_return(7)
      @board = Board.new
    end

    it 'returns all possible moves from its location (including moves that go off board)' do

      knight = Knight.new(board, [3,2], 'white')
      expect(knight.all_moves).to contain_exactly(
        [4, 4], [5, 3], [5, 1], [4, 0],
        [2, 0], [1, 1], [1, 3], [2, 4]
      )
    end

    it 'returns all moves from its location that stay on board' do
      knight = Knight.new(board, [0,5], 'white')
      # knight.find_moves
      expect(knight.in_bounds_moves).to contain_exactly(
        [2, 6], [1, 7], [1, 3], [2, 4]
      )
    end
  end
end