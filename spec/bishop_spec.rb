require './lib/bishop.rb'
require './lib/board.rb'

describe Bishop do
  attr_reader :board

  before { @board = Board.new }

  describe '#set_valid_moves' do
    it 'sets @valid_moves' do
      bishop = Bishop.new(board, [6, 2], 'whie')
      bishop.set_valid_moves
      expect(bishop.valid_moves).to contain_exactly(
        [5, 3], [4, 4], [3, 5], [7, 3]
      )
    end
  end

  describe '#set_valid_captures' do
    it 'sets @valid_captures' do
      bishop = Bishop.new(board, [2, 3], 'black')
      bishop.set_valid_captures
      expect(bishop.valid_captures).to contain_exactly([0, 1], [4, 1])
    end

    it 'sets @valid_captures' do
      bishop = Bishop.new(board, [7, 5], 'black')
      bishop.set_valid_captures
      expect(bishop.valid_captures).to contain_exactly([3, 1])
    end

    it 'sets @valid_captures' do
      bishop = Bishop.new(board, [0, 3], 'white')
      bishop.set_valid_captures
      expect(bishop.valid_captures).to contain_exactly([3, 6])
    end
  end

  describe '#points' do
    it 'returns point value based on location' do
      bishop = WhiteBishop.new(board, [0, 3])
      expect(bishop.points).to eq(320)
    end

    it 'works for another location' do
      bishop = WhiteBishop.new(board, [6, 6])
      expect(bishop.points).to eq(330)
    end

    it 'works for another location' do
      bishop = WhiteBishop.new(board, [1, 2])
      expect(bishop.points).to eq(340)
    end

    it 'works for a black bishop' do
      bishop = BlackBishop.new(board, [6, 6])
      expect(bishop.points).to eq(-335)
    end

    it 'works for a black bishop at another location' do
      bishop = BlackBishop.new(board, [1, 1])
      expect(bishop.points).to eq(-330)
    end
  end
end