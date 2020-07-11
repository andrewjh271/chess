require './lib/queen.rb'
require './lib/board.rb'

describe Queen do
  attr_reader :board

  before { @board = Board.new }

  describe '#set_valid_moves' do
    it 'sets @valid_moves' do
      queen = Queen.new(board, [3, 2], 'white')
      queen.set_valid_moves
      expect(queen.valid_moves).to contain_exactly(
        [0, 2], [1, 2], [2, 2], [4, 2], [5, 2], [6, 2], [7, 2], [2, 3],
        [1, 4], [0, 5], [3, 3], [3, 4], [3, 5], [4, 3], [5, 4], [6, 5]
      )
    end
  end

  describe '#set_valid_captures' do
    it 'sets @valid_captures' do
      queen = Queen.new(board, [1, 5], 'white')
      queen.set_valid_captures
      expect(queen.valid_captures).to contain_exactly([0, 6], [1, 6], [2, 6])
    end

    it 'sets @valid_captures' do
      queen = Queen.new(board, [5, 3], 'black')
      queen.set_valid_captures
      expect(queen.valid_captures).to contain_exactly([3, 1], [5, 1], [7, 1])
    end
  end

  describe '#move' do
    it 'returns correct value' do
      queen = WhiteQueen.new(board, [5, 3])
      expect(queen.points).to eq(905)
    end

    it 'returns correct value for another location' do
      queen = WhiteQueen.new(board, [7, 6])
      expect(queen.points).to eq(890)
    end

    it 'works for black queen' do
      queen = BlackQueen.new(board, [2, 6])
      expect(queen.points).to eq(-905)
    end

    it 'works for another black queen' do
      queen = BlackQueen.new(board, [6, 5])
      expect(queen.points).to eq(-900)
    end
  end
end