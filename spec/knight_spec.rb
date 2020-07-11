require './lib/knight.rb'
require './lib/board.rb'

describe Knight do
  
  attr_reader :board
  
  before do
    # @board = double(:board)
    # allow(board).to receive(:MAX).and_return(7)
    @board = Board.new
  end
  
  describe '#all_moves' do
    it 'returns all possible moves from its location (including moves that go off board)' do
      knight = Knight.new(board, [3,2], 'white')
      expect(knight.all_moves).to contain_exactly(
        [4, 4], [5, 3], [5, 1], [4, 0],
        [2, 0], [1, 1], [1, 3], [2, 4]
      )
    end
  end

  describe '#in_bounds_moves' do
    it 'returns all moves from its location that stay on board' do
      knight = Knight.new(board, [0,5], 'white')
      # knight.find_moves
      expect(knight.in_bounds_moves).to contain_exactly(
        [2, 6], [1, 7], [1, 3], [2, 4]
      )
    end
  end

  describe '#set_valid_moves' do
    it 'sets @valid_moves' do
      knight = Knight.new(board, [6,0], 'white')
      knight.set_valid_moves
      expect(knight.valid_moves).to contain_exactly([5, 2], [7, 2])
    end

    it 'sets @valid_moves' do
      knight = Knight.new(board, [6, 4], 'black')
      knight.set_valid_moves
      expect(knight.valid_moves).to contain_exactly([4, 5], [4, 3], [5, 2], [7, 2])
    end
  end

  describe '#set_valid_captures' do
    it 'sets @valid_captures' do
      knight = Knight.new(board, [6,0], 'white')
      knight.set_valid_captures
      expect(knight.valid_captures).to eq([])
    end

    it 'sets @valid_captures' do
      knight = Knight.new(board, [2,2], 'black')
      knight.set_valid_captures
      expect(knight.valid_captures).to contain_exactly([0, 1], [1, 0], [3, 0], [4, 1])
    end
  end

  describe '#points' do
    it 'returns the correct number of points' do
      knight = WhiteKnight.new(board, [2, 2])
      expect(knight.points).to eq(330)
    end

    it 'works for a different square' do
      knight = WhiteKnight.new(board, [4, 4])
      expect(knight.points).to eq(340)
    end

    it 'works for a black knight' do
      knight = BlackKnight.new(board, [4, 6])
      expect(knight.points).to eq(-325)
    end

    it 'works for another black knight' do
      knight = BlackKnight.new(board, [1, 2])
      expect(knight.points).to eq(-320)
    end
  end
end