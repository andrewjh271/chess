require './lib/rook.rb'
require './lib/board.rb'

describe Rook do
  attr_reader :board

  before { @board = Board.new }

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

  describe '#points' do
    it 'returns the correct number of points' do
      rook = WhiteRook.new(board, [7, 3])
      expect(rook.points).to eq(495)
    end

    it 'works for another location' do
      rook = WhiteRook.new(board, [2, 6])
      expect(rook.points).to eq(510)
    end

    it 'works for black rook' do
      rook = BlackRook.new(board, [3, 6])
      expect(rook.points).to eq(-500)
    end

    it 'works for another black rook' do
      rook = BlackRook.new(board, [0, 1])
      expect(rook.points).to eq(-505)
    end
  end
end