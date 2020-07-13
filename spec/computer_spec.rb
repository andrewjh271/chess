require './lib/computer.rb'
require './lib/board.rb'

describe Computer do

  board = Board.new
  subject { Computer.new('White') }

  describe '#load_openings' do
    it 'returns an array full of move lists' do
      expect(subject.load_openings).to be_a(Array)
    end
  end

  describe '#find_book_move' do
    it 'returns the next move if current move list finds a match' do
      subject.set_board(board)

      board.move('f4')
      board.move('c5')

      board.move('Nf3')
      board.move('d5')

      board.move('g3')
      board.move('Nc6')

      board.move('Bg2')
      board.move('e6')

      board.move('O-O')
      board.move('Bd6')

      board.move('Nc3')
      board.move('Nf6')

      board.move('d3')
      board.move('d4')

      board.move('Nb5')
      board.move('Nd5')
      expect(subject.find_book_move).to eq('c4')
    end

    it 'returns false if current move list does not find a match' do
      subject.set_board(board)
      board.move('Nfxd4')
      expect(subject.find_book_move).to eq(false)
    end
  end
end