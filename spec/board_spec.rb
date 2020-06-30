require './lib/board.rb'

describe Board do
  
  describe '#in_check?' do
    board = Board.new

    it { expect(board).not_to be_in_check }

    it "returns true if current side's king is in check" do
      board.move('e4')
      board.move('e5')
      board.move('Bc4')
      board.move('Bc5')
      expect(board.move('Bc2')).to eq(false)

      board.move('Bxf7')
      expect(board).to be_in_check
    end

    it "returns false if current side's king is not in check" do
      board.move('Kxf7')
      expect(board).not_to be_in_check
    end

    it "returns false if current side's king is not in check" do
      board.move('Nf3')
      expect(board).not_to be_in_check
    end

    it "returns true if current side's king is in check" do
      board.move('Bxf2')
      expect(board).to be_in_check
    end

    it "returns false if current side's king is not in check" do
      board.move('Kf1')
      expect(board).not_to be_in_check
    end

    it "returns false if current side's king is not in check" do
      board.move('h5')
      expect(board).not_to be_in_check
    end

    it "returns true if current side's king is in check" do
      board.move('Nxe5')
      expect(board).to be_in_check
    end

  end

  describe '#move' do
    context 'king in check' do
      board = Board.new

      it 'does not allow move that results in king being in check' do
        board.move('e4')
        board.move('e5')

        board.move('Bc4')
        board.move('Bc5')

        board.move('Bxf7')
        expect(board.move('Nc6')).to eq(false)
        expect(board.move('Qh4')).to eq(false)
      end

      it 'does allow moves that captures checking piece' do
        expect(board.move('Kxf7')).to eq(true)
      end

      it 'does allow moves that block check' do
        board.move('d4')
        board.move('Bb4')

        expect(board.move('Qd2')).to eq(true)
      end
    end

    context 'en passant' do
      board = Board.new

      it 'allows en passant for white' do
        board.move('e4')
        board.move('d5')

        board.move('e5')
        board.move('f5')

        expect(board.move('exf6')).to eq(true)
      end

      it 'allows en passant for black' do
        board.move('d4')

        board.move('c4')
        expect(board.move('dxc3')).to eq(true)
      end

      it 'only allows en passant on first chance' do
        board.move('d4')
        board.move('a5')

        board.move('d5')
        board.move('c5')

        board.move('h4')
        board.move('a4')

        expect(board.move('dxc6')).to eq(false)
      end

      it 'works at edge of board' do
        board.move('b4')
        expect(board.move('axb3')).to eq(true)
      end

      it 'does not allow invalid captures' do
        board = Board.new

        board.move('e4')
        board.move('g5')

        board.move('e5')
        board.move('f5')

        board.move('exf6')
        board.move('e5')

        board.move('Nc3')
        board.move('e4')

        board.move('Nd5')
        board.move('e3')

        board.move('fxe3')
        board.move('g4')

        board.move('h4')
        expect(board.move('gxf3')).to eq(false)
        expect(board.move('fxh3')).to eq(false)
        expect(board.move('gxh3')).to eq(true)
      end

      it 'finds correct pawn if multiple en_passants are possible' do
        board = Board.new

        board.move('e4')
        board.move('c6')

        board.move('g4')
        board.move('b5')

        board.move('e5')
        board.move('a5')

        board.move('g5')
        board.move('f5')

        expect(board.move('gxf6')).to eq(true)
      end

      it 'does not throw error if bad input given' do
        expect(board.move('xf6')).to eq(false)
      end
    end

    context 'promotion' do
      board = Board.new
      
      it 'allows capture promotion to WhiteKnight' do
        board.move('d4')
        board.move('e5')

        board.move('dxe5')
        board.move('f6')

        board.move('exf6')
        board.move('d5')

        board.move('fxg7')
        board.move('d4')

        board.move('gxh8=N')
        expect(board.squares[7][7]).to be_a(WhiteKnight)
      end

      it 'allows promotion to BlackQueen' do
        board.move('d3')

        board.move('Bg5')
        board.move('dxc2')

        board.move('Nf3')
        board.move('c1=Q')
        expect(board.squares[2][0]).to be_a(BlackQueen)
      end
    end

    context '+ and # appended to moves' do
      board = Board.new
      it 'allows + if move comes with check' do
        board.move('e4')
        board.move('e5')

        board.move('Bc4')
        board.move('Bc5')

        expect(board.move('Bxf7+')).to eq(true)
      end

      it 'does not allow + if move does not come with check' do
        expect(board.move('Kxf7+')).to eq(false)
        expect(board.move('Kxf7')).to eq(true)
      end

      it 'allows + if different move comes with check' do
        board.move('Nf3')
        expect(board.move('Bxf2+')).to eq(true)
      end

      it 'does not allow + if different move does not come with check' do
        expect(board.move('Kf1+')).to eq(false)
        expect(board.move('Kf1')).to eq(true)
      end

      it 'does not require + even if move comes with check' do
        board.move('Qf6')

        expect(board.move('Nxe5')).to eq(true)
      end

      it 'allows + for discovered check' do
        board.move('Ke7')

        board.move('Qh5')
        expect(board.move('Bh4+')).to eq(true)
      end

      it 'works with en passant when no + for check' do
        board.move('Ke2')
        board.move('Kd6')

        board.move('Ng6')
        board.move('c5')

        board.move('a4')
        board.move('c4')

        board.move('d4')
        expect(board.move('cxd3')).to eq(true)
      end

      it 'works with en passant when + is given for check' do
        board.move('Kxd3')
        board.move('Kc7')

        board.move('a5')
        board.move('b5')

        expect(board.move('axb6+')).to eq(true)
      end

      it 'works with kingside castling when no + for check' do
        board = Board.new
        board.move('e4')
        board.move('f5')

        board.move('exf5')
        board.move('g6')

        board.move('fxg6')
        board.move('hxg6')

        board.move('d4')
        board.move('Nh6')

        board.move('Bc4')
        board.move('g5')

        board.move('f3')
        board.move('g4')

        board.move('Bxh6')
        board.move('gxf3')

        board.move('Nxf3')
        board.move('Bxh6')

        board.move('Ng5')
        board.move('Kf8')

        expect(board.move('0-0')).to eq(true)
      end

      it 'works with queenside castling when + is given for check' do
        board = Board.new

        board.move('d4')
        board.move('c5')

        board.move('dxc5')
        board.move('Qb6')

        board.move('cxb6')
        board.move('d5')

        board.move('Bg5')
        board.move('Bh3')

        board.move('Nd2')
        board.move('Na6')

        board.move('Ne4')
        board.move('dxe4')

        board.move('Qc1')
        board.move('Bxg2')

        board.move('Kd1')
        expect(board.move('0-0-0+')).to eq(true)
      end
    end

    context 'Checkmate' do
      it 'recognizes checkmate' do
        board = Board.new
        board.move('f4')
        board.move('e5')

        board.move('g4')
        expect(board.move('Qh4#')).to eq(true)
      end

      it 'adds # when not given' do
        board = Board.new
        board.move('d4')
        board.move('Nf6')

        board.move('c4')
        board.move('c5')

        board.move('d5')
        board.move('b5')

        board.move('cxb5')
        board.move('a6')

        board.move('cxb5')
        board.move('a6')

        board.move('Nc3')
        board.move('axb5')

        board.move('e4')
        board.move('b4')

        board.move('Nb5')
        board.move('Nxe4')

        board.move('Qe2')
        board.move('Nf6')

        expect(board.move('Nd6')).to eq(true)
      end
    end

    context 'Full game with lots of bad input along the way' do
      board = Board.new

      it 'works with first set of Pawn moves' do
        # board.flip_board
        board.move('e4')
        board.move('e6')

        board.move('d4')
        board.move('d5')

        board.move('e5')
        expect(board.move('c4')).to eq(false)
        expect(board.move('c5')).to eq(true)
        expect(board.squares[3][3]).to be_a(WhitePawn)
      end

      it 'works with first Knight, Bishop, and Queen moves' do
        board.move('c3')
        board.move('Nc6')

        expect(board.move('Nf2')).to eq(false)
        expect(board.move('Nf3')).to eq(true)
        expect(board.move('Bf5')).to eq(false)
        expect(board.move('Bd7')).to eq(true)

        board.move('a3')
        board.move('f6')

        board.move('Bd3')
        expect(board.move('Qd6')).to eq(false)
        expect(board.move('Qc7')).to eq(true)

        expect(board.squares[2][6]).to be_a(BlackQueen)
        expect(board.squares[3][2]).to be_a(WhiteBishop)
        expect(board.squares[5][2]).to be_a(WhiteKnight)
      end

      it 'works with castling and does not accept invalid castling' do
        expect(board.move('0-0-0')).to eq(false)
        expect(board.move('0-0+')).to eq(false)
        expect(board.move('0-0')).to eq(true)
        expect(board.move('0-0')).to eq(false)
        expect(board.move('0-0-0+')).to eq(false)
        expect(board.move('0-0-0')).to eq(true)
        expect(board.squares[6][0]).to be_a(WhiteKing)
        expect(board.squares[3][7]).to be_a(BlackRook)
      end

      it 'works with valid and invalid captures' do
        board.move('Qe2')
        board.move('h6')

        board.move('b4')
        board.move('c4')

        board.move('Bc2')
        board.move('f5')

        board.move('Nh4')
        board.move('Be8')

        board.move('f4')
        board.move('Be7')

        expect(board.move('Nxg6')).to eq(false)
        expect(board.move('Nxf5')).to eq(true)
        expect(board.move('gxf5')).to eq(false)
        expect(board.move('exf5')).to eq(true)
        expect(board.squares[5][4]).to be_a(BlackPawn)
        expect(board.squares[5][4].location).to eq([5, 4])
      end

      it 'works with valid +' do
        expect(board.move('Bxf5+')).to eq(true)
      end

      it 'does not accept move that results in check' do
        expect(board.move('g5')).to eq(false)
        expect(board.move('Nxe5')).to eq(false)
      end

      it 'does not accept move with invalid +' do
        expect(board.move('Kb8+')).to eq(false)
        expect(board.move('Kb8')).to eq(true)
      end

      it 'is not derailed by more invalid captures' do
        board.move('Qg4')
        board.move('g5')

        expect(board.move('Qxf4')).to eq(false)
        expect(board.move('Bxg5')).to eq(false)
        expect(board.move('fxg5')).to eq(true)
        expect(board.move('Nxh6')).to eq(false)
        expect(board.move('hxg5')).to eq(true)
        expect(board.squares[6][4]).to be_a(BlackPawn)

        board.move('Bxg5')
        board.move('Bh5')

        board.move('Qg3')
        board.move('Bxg5')

        expect(board.move('Qxg8')).to eq(false)
        expect(board.move('Qxg5')).to eq(true)
      end

      it 'expects disambiguity if multiple Knights can move to square' do
        expect(board.move('Ne7')).to eq(false)
        expect(board.move('Nfe7')).to eq(false)
        expect(board.move('Nge7')).to eq(true)
        expect(board.squares[6][7]).to be_nil
      end

      it 'expects disambiguity if multiple Rooks can move to square' do
        board.move('Nd2')
        expect(board.move('Rg8')).to eq(false)
        # rank (8) is not the needed disambiguity
        expect(board.move('R8g8')).to eq(false)
        expect(board.move('Rdg8')).to eq(true)
        expect(board.squares[3][7]).to be_nil
      end

      it 'finishes game' do
        board.move('Qe3')
        board.move('Nxf5')

        board.move('Rxf5')
        board.move('Qh7')

        board.move('Rf6')
        board.move('Be2')

        board.move('h3')
        board.move('Bd3')

        board.move('Kh2')
        board.move('Ne7')

        board.move('Nf3')
        board.move('Nf5')

        board.move('Qf4')
        board.move('Ka8')

        board.move('Rg1')
        board.move('Qh5')

        board.move('e6')
        board.move('Be4')

        board.move('Rf1')
        board.move('Rg3')

        board.move('Rxf5')
        board.move('Qxh3+')
        
        board.move('gxh3')
        expect(board.move('Rhxh3#')).to eq(true)
      end
    end

  end

end