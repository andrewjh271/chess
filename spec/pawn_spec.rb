require './lib/pawn.rb'
require './lib/board.rb'

describe WhitePawn do
  attr_reader :board

  before { @board = Board.new }

  describe '#set_valid_moves' do
    it 'sets @valid_moves' do
      pawn = board.squares[5][1]
      pawn.set_valid_moves
      expect(pawn.valid_moves).to contain_exactly([5, 2], [5, 3])
    end
  end

  describe '#set_valid_captures' do
    it 'sets @valid_captures' do
      pawn = WhitePawn.new(board, [5, 5])
      pawn.set_valid_captures
      expect(pawn.valid_captures).to contain_exactly([4, 6], [6, 6])
    end

    it 'sets @valid_captures' do
      pawn = WhitePawn.new(board, [4, 4])
      pawn.set_valid_captures
      expect(pawn.valid_captures).to eq([])
    end
  end
end

describe BlackPawn do
  attr_reader :board

  before { @board = Board.new }

  describe '#set_valid_moves' do
    it 'sets @valid_moves' do
      pawn = board.squares[1][6]
      pawn.set_valid_moves
      expect(pawn.valid_moves).to contain_exactly([1, 5], [1, 4])
    end
  end

  describe '#set_valid_captures' do
    it 'sets @valid_captures' do
      pawn = BlackPawn.new(board, [2, 2])
      pawn.set_valid_captures
      expect(pawn.valid_captures).to contain_exactly([1, 1], [3, 1])
    end

    it 'sets @valid_captures' do
      pawn = BlackPawn.new(board, [4, 4])
      pawn.set_valid_captures
      expect(pawn.valid_captures).to eq([])
    end
  end
end