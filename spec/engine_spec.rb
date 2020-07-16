require './lib/board.rb'

# tests Engine module, which is used by Board class
describe Engine do

  describe '#get_input' do
    board = Board.new

    it 'translates pawn move into algebraic notation' do
      expect(board.get_input([board.squares[3][1], [3, 3]])).to eq('d4')
    end

    it 'translates knight move into algebraic notation' do
      expect(board.get_input([board.squares[1][0], [2, 2]])).to eq('Nc3')
    end

    it 'translates bishop move into algebraic notation' do
      board.move('e4')
      board.move('e5')

      expect(board.get_input([board.squares[5][0], [2, 3]])).to eq('Bc4')
      board.move('Bc4')
    end

    it 'translates queen move into algebraic notation' do
      expect(board.get_input([board.squares[3][7], [7, 3]])).to eq('Qh4')
    end

    it 'adds clarifying file when disambiguation needed' do
      board.move('Qh4')
      board.move('Nc3')

      expect(board.get_input([board.squares[2][2], [4, 1]])).to eq('Nce2')
    end

    it 'translates queen capture that comes with check' do
      board.move('a5')
      # + will be added after algebraic input is entered into Board#move
      expect(board.get_input([board.squares[7][3], [5, 1]])).to eq('Qxf2')
    end

    it 'adds clarifying rank when file does not clarify disambiguation' do
      board.move('Nce2')
      board.move('a4')
      board.move('Ng3')
      board.move('a3')

      expect(board.get_input([board.squares[6][0], [4, 1]])).to eq('N1e2')
    end

    it 'translates pawn capture' do
      board.move('N1e2')
      expect(board.get_input([board.squares[0][2], [1, 1]])).to eq('axb2')
    end

    it 'translates promoting pawn into queen' do
      board.move('axb2')

      board.move('O-O')
      expect(board.get_input([board.squares[1][1], [2, 0]])).to eq('bxc1=Q')
    end

    board2 = Board.new
    it 'translates another promoting pawn into queen' do
      board2.move('c4')
      board2.move('c5')

      board2.move('d4')
      board2.move('cxd4')

      board2.move('e3')
      board2.move('d5')

      board2.move('c5')
      board2.move('Be6')

      board2.move('c6')
      board2.move('dxe3')

      board2.move('c7')
      board2.move('e2')

      board2.move('c7')
      board2.move('e2')

      expect(board2.get_input([board2.squares[2][6], [2, 7]])).to eq('c8=Q')
      board2.move('c8=Q')
    end

    it 'translates yet another promoting pawn into queen' do
      board2.move('g5')

      board2.move('a4')
      expect(board2.get_input([board2.squares[4][1], [5, 0]])).to eq('exf1=Q')
      board2.move('exf1=Q')
    end

    it 'translates yet another promoting pawn into queen' do
      board2.move('Kd2')
      board2.move('g4')

      board2.move('a5')
      board2.move('g3')

      board2.move('a6')
      board2.move('gxf2')

      board2.move('axb7')
      board2.move('Qa6')

      expect(board2.get_input([board.squares[1][6], [0, 7]])).to eq('bxa8=Q')
      board2.move('bxa8=Q')
      expect(board2.get_input([board.squares[5][1], [5, 0]])).to eq('f1=Q')
    end

    it 'translates king move' do
      board.move('bxc1=Q')

      board.move('Qxc1')
      expect(board.get_input([board.squares[4][7], [3, 7]])).to eq('Kd8')
    end

    it 'translates rook capture' do
      board.move('Kd8')

      board.move('Qa3')
      expect(board.get_input([board.squares[0][7], [0, 2]])).to eq('Rxa3')
    end

    it 'adds clarifying file when rook disambiguation needed' do
      board.move('Rxa3')
      expect(board.get_input([board.squares[5][0], [2, 0]])).to eq('Rfc1')
    end
  end

  # #find_valid_moves will always include castling, and let #move filter it out later
  describe '#find_valid_moves' do
    board = Board.new

    it 'contains all valid moves in opening position' do
      expect(board.find_valid_moves).to contain_exactly(
        'a4', 'a3', 'b4', 'b3', 'c4', 'c3', 'd4', 'd3', 'e4', 'e3', 'f4', 'f3', 'g4', 'g3', 'h4', 'h3', 'Na3', 'Nc3', 'Nf3', 'Nh3', 'O-O', 'O-O-O'
      )
    end

    it 'works for black as well, and includes en passant if appropriate' do
      board.move('e4')
      board.move('d5')

      board.move('Nf3')
      board.move('Bg4')

      board.move('Ba6')
      board.move('d4')

      board.move('c4')

      expect(board.find_valid_moves).to contain_exactly(
        'bxa6', 'Nxa6', 'b6', 'b5', 'c6', 'c5', 'Nc6', 'Nd7', 'Qc8', 'Qd7', 'Qd6', 'Qd5',
        'dxc3', 'd3', 'Kd7', 'e6', 'e5', 'Bc8', 'Bd7', 'Be6', 'Bf5', 'Bh5', 'Bh3', 'Bxf3',
        'f6', 'f5', 'g6', 'g5', 'h6', 'h5', 'Nf6', 'Nh6', 'O-O', 'O-O-O'
      )
    end
  end

  describe '#evaluate' do
    board = Board.new

    it 'finds score for opening position' do
      expect(board.evaluate(board)[1]).to eq(0)
    end

    it 'finds score after 3 captures' do
      board.move('e4')
      board.move('e5')

      expect(board.evaluate(board)[1]).to eq(0)
      board.move('Ba6')
      expect(board.evaluate(board)[1]).to eq(0)
      board.move('bxa6')
      expect(board.evaluate(board)[1]).to eq(-315)

      board.move('d4')
      expect(board.evaluate(board)[1]).to eq(-275)
      board.move('exd4')
      expect(board.evaluate(board)[1]).to eq(-400)

      board.move('Qxd4')
      expect(board.evaluate(board)[1]).to eq(-265)
    end

    it 'evaluates correctly when a pawn promotes into queen' do
      board = Board.new

      board.move('c4')
      board.move('c5')

      board.move('d4')
      board.move('cxd4')

      board.move('e3')
      board.move('d5')

      board.move('c5')
      board.move('Be6')

      board.move('c6')
      board.move('dxe3')

      board.move('c7')
      board.move('e2')

      board.move('c7')
      board.move('e2')

      board.move('c8=Q')
      expect(board.evaluate(board)[1]).to eq(520)
    end
  end

  describe 'choose_move' do
    context 'depth of 1' do
      it 'finds mate in 1' do
        board = Board.new
        board.move('e4')
        board.move('e5')

        board.move('Bc4')
        board.move('Bc5')

        board.move('Qh5')
        board.move('Nf6')
        # checkmate sign # not added until move is actually made
        expect(board.choose_move(1)).to eq('Qxf7')
      end

      it 'finds a mate for black' do
        board = Board.new

        board.move('f4')
        board.move('e5')

        board.move('g4')
        expect(board.choose_move(1)).to eq('Qh4')
      end
    end

    context 'depth of 2' do
      it 'finds mate in 1' do
        board = Board.new

        board.move('Nf3')
        board.move('h6')

        board.move('e3')
        board.move('g6')

        board.move('Bc4')
        board.move('d6')

        board.move('Ne5')
        board.move('b6')

        expect(board.choose_move(2)).to eq('Bxf7')
      end

      it 'finds mate in 1 for black' do
        board = Board.new

        board.move('e4')
        board.move('e5')

        board.move('Nf3')
        board.move('Nf6')

        board.move('Nxe5')
        board.move('Nxe4')

        board.move('Nxf7')
        board.move('Qh4')

        board.move('Nxh8')
        expect(board.choose_move(2)).to eq('Qxf2')
      end
    end

    context 'depth of 3' do
      it 'finds mate in 2' do
        board = Board.new

        board.move('f3')
        board.move('e6')

        board.move('Nc3')
        board.move('Bd6')

        board.move('b3')
        board.move('Qh4+')

        board.move('g3')
        expect(board.choose_move(3)).to eq('Qxg3').or eq('Bxg3')
      end

      it 'finds 3 move tactic' do
        board = Board.new

        board.move('e4')
        board.move('e5')

        board.move('Nf3')
        board.move('Nf6')

        board.move('Nxe5')
        board.move('Nxe4')

        board.move('Qe2')
        board.move('Nf6')

        expect(board.choose_move(3)).to eq('Nc6')
      end

      board = Board.new
      it 'finds another 3 move tactic' do
        board.move('d4')
        board.move('d5')

        board.move('c4')
        board.move('e6')

        board.move('Nc3')
        board.move('Nf6')

        board.move('Bg5')
        board.move('Nbd7')

        board.move('cxd5')
        board.move('exd5')

        board.move('Nxd5')
        board.move('Nxd5')

        board.move('Bxd8')
        expect(board.choose_move(3)).to eq('Bb4')
      end

      it 'finds a clear best move when depth is higher than needed' do
        board.move('Bb4')

        board.move('Qd2')
        board.move('Bxd2')

        board.move('Kxd2')
        board.move('Kxd8')

        board.move('e4')
        board.move('Nc3')

        board.move('bxc3')
        board.move('b5')

        board.move('Bxb5')
        board.move('c6')

        board.move('Bxc6')
        board.move('h5')

        expect(board.choose_move(3)).to eq('Bxa8')
      end

      it 'chooses 1 move checkmate over 3 move checkmate' do
        board.move('Nf3')
        board.move('g5')

        board.move('Nxg5')
        board.move('Rb8')

        board.move('Nxf7')
        board.move('Kc7')

        board.move('Nxh8')
        board.move('h4')

        board.move('Bxd7')
        board.move('h3')

        board.move('Bxc8')
        board.move('Rb7')

        board.move('Bxb7')
        board.move('Kb8')

        board.move('gxh3')
        board.move('a6')

        board.move('Rhg1')
        board.move('a5')

        board.move('Rg7')
        board.move('a4')

        board.move('Bd5')
        board.move('Kc8')

        board.move('Rb1')
        board.move('Kd8')

        expect(board.choose_move(3)).to eq('Rb8')
      end
    end

    context 'depth of 4' do
      it 'finds a mate in 3' do
        board = Board.new

        board.move('d4')
        board.move('f5')

        board.move('Bg5')
        board.move('h6')

        board.move('Bf4')
        board.move('g5')

        board.move('Bg3')
        board.move('f4')

        board.move('e3')
        board.move('h5')

        board.move('Bd3')
        board.move('Rh6')

        expect(board.choose_move(4)).to eq('Qxh5')
      end
    end

    context 'depth of 5' do
      # about 5 minutes to run
      xit 'finds mate in 3' do
        board = Board.new

        board.move('f4')
        board.move('e5')

        board.move('fxe5')
        board.move('d6')

        board.move('exd6')
        board.move('Bxd6')

        board.move('Nc3')
        expect(board.choose_move(5)).to eq('Qh4')
      end
    end
  end
end
