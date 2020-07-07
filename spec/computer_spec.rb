require './lib/computer.rb'
require './lib/board.rb'

describe Computer do

  describe '#get_input' do
    board = Board.new
    comp = Computer.new('Black')
    comp.set_board(board)


    # it 'translates pawn move into algebraic notation' do
    #   expect(comp.get_input([board.squares[3][1], [3, 3]])).to eq('d4')
    # end

    # it 'translates knight move into algebraic notation' do
    #   expect(comp.get_input([board.squares[1][0], [2, 2]])).to eq('Nc3')
    # end

    # it 'translates bishop move into algebraic notation' do
    #   board.move('e4')
    #   board.move('e5')

    #   expect(comp.get_input([board.squares[5][0], [2, 3]])).to eq('Bc4')
    #   board.move('Bc4')
    # end

    # it 'translates queen move into algebraic notation' do
    #   expect(comp.get_input([board.squares[3][7], [7, 3]])).to eq('Qh4')
    # end

    # it 'adds clarifying file when disambiguation needed' do
    #   board.move('Qh4')
    #   board.move('Nc3')

    #   expect(comp.get_input([board.squares[2][2], [4, 1]])).to eq('Nce2')
    # end

    # it 'translates queen capture that comes with check' do
    #   board.move('a5')
    #   # + will be added after algebraic input is entered into Board#move
    #   expect(comp.get_input([board.squares[7][3], [5, 1]])).to eq('Qxf2')
    # end

    # it 'translates kingside castling' do
    #   board.move('Nf3')
    #   board.move('a4')
    #   board.move('b4')

      # expect(comp.get_input([board.squares[2][2], [4, 1]])).to eq('Nce2')
    # end
  end
end