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

  describe '#points' do
    context 'opening/middlegame' do
      it 'returns the correct numbers of points' do
        king = WhiteKing.new(board, [0, 5])
        expect(king.points).to eq(19970)
      end
  
      it 'works for another location' do
        king = WhiteKing.new(board, [6, 0])
        expect(king.points).to eq(20030)
      end

      it 'works for black king' do
        king = BlackKing.new(board, [1, 6])
        expect(king.points).to eq(-20020)
      end
    end

    context 'middle transistions to endgame' do
      board2 = Board.new
      it 'returns the correct number of points' do
        board2.move('c4')
        board2.move('d6')

        board2.move('d4')
        board2.move('e5')

        board2.move('dxe5')
        board2.move('dxe5')

        board2.move('Qxd8+')
        board2.move('Kxd8')

        expect(board2.squares[3][7].points).to eq(-20000)
      end

      it 'works as kings move up the board' do
        board2.move('Kd2')
        board2.move('Kd7')

        board2.move('Kc3')
        board2.move('Ke6')

        expect(board2.squares[2][2].points).to eq(19980)
        expect(board2.squares[4][5].points).to eq(-19980)
      end

      it 'works when transitions to endgame' do
        board2.move('Bh6')
        board2.move('Nxh6')

        board2.move('Na3')
        board2.move('Bxa3')

        board2.move('Rd1')
        board2.move('Rd8')

        board2.move('Rxd8')
        board2.move('Nc6')

        board2.move('bxa3')
        board2.move('Nxd8')

        expect(board2.squares[2][2].points).to eq(20020)
        expect(board2.squares[4][5].points).to eq(-20030)
      end
    end
    
  end

end