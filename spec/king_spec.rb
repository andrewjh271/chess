require './lib/king.rb'
require './lib/board.rb'

describe King do
  attr_reader :board

  before { @board = Board.new }

  describe '#set_valid_moves' do
    it 'sets @valid_moves' do
      king = King.new(board, [3, 2], 'white')
      king.set_valid_moves
      expect(king.valid_moves).to contain_exactly(
        [3, 3], [4, 3], [4, 2], [2, 2], [2, 3]
      )
    end
  end

  describe '#set_valid_captures' do
    it 'sets @valid_captures' do
      king = King.new(board, [3, 2], 'white')
      king.set_valid_captures
      expect(king.valid_captures).to eq([])
    end

    it 'sets @valid_captures' do
      king = King.new(board, [6, 2], 'black')
      king.set_valid_captures
      expect(king.valid_captures).to contain_exactly([5, 1], [6, 1], [7, 1])
    end

    it 'sets @valid_captures' do
      king = King.new(board, [0, 5], 'white')
      king.set_valid_captures
      expect(king.valid_captures).to contain_exactly([0, 6], [1, 6])
    end
  end

end