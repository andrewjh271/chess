require './lib/rook.rb'
require './lib/board.rb'

describe Rook do
  attr_reader :board

  before { @board = Board.new }

  describe '#all_moves' do
    it 'returns all possible moves from its location (including moves that go off board)' do
      rook = Rook.new(board, [0, 3], 'white')
      expect(rook.all_moves).to contain_exactly(
        [0, -4], [0, -3], [0, -2], [0, -1], [0, 0], [0, 1], [0, 2],
        [0, 4], [0, 5], [0, 6], [0, 7], [0, 8], [0, 9], [0, 10],
        [-7, 3], [-6, 3], [-5, 3], [-4, 3], [-3, 3], [-2, 3], [-1, 3],
        [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3]
      )
    end
  end

  describe '#in_bounds_moves' do
    it 'returns all moves from its location that stay on board' do
      rook = Rook.new(board, [1, 1], 'white')
      expect(rook.in_bounds_moves).to contain_exactly(
        [0, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7],
        [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [1, 0]
      )
    end
  end

  describe '#set_valid_moves' do
    it 'sets @valid_moves' do
      rook = Rook.new(board, [3, 2], 'white')
      rook.set_valid_moves
      expect(rook.valid_moves).to contain_exactly(
        [0, 2], [1, 2], [2, 2], [4, 2], [5, 2], [6, 2],
        [7, 2], [3, 3], [3, 4], [3, 5]
      )
    end
  end

  describe '#set_valid_captures' do
    it 'sets @valid_captures' do
      rook = Rook.new(board, [7, 3], 'black')
      rook.set_valid_captures
      expect(rook.valid_captures).to eq([[7, 1]])
    end

    it 'sets @valid_captures' do
      rook = Rook.new(board, [2, 2], 'black')
      rook.set_valid_captures
      expect(rook.valid_captures).to eq([[2, 1]])
    end

    it 'sets @valid_captures' do
      rook = Rook.new(board, [0, 4], 'white')
      rook.set_valid_captures
      expect(rook.valid_captures).to eq([[0, 6]])
    end
  end
end