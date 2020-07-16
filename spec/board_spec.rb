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
      
      it 'ignores bad input' do
        board.move('d4')
        board.move('e5')

        board.move('dxe5')
        board.move('f6')

        board.move('exf6')
        board.move('d5')

        board.move('fxg7')
        board.move('d4')

        expect(board.move('gxh8')).to eq(false)
        expect(board.move('gxh8=G')).to eq(false)
        expect(board.move('gxh8N')).to eq(false)
        expect(board.move('gxh8Knight')).to eq(false)
      end

      it 'allows capture promotion to WhiteKnight' do
        expect(board.move('gxh8=N')).to eq(true)
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

      it 'allows promotion to come with check' do
        board.move('e4')
        board.move('c5')

        board.move('e5')
        board.move('c4')

        board.move('e6')
        board.move('c3')

        board.move('e7')
        board.move('c2')

        expect(board.move('exf8=R')).to eq(true)
      end

      it 'allows promotion to come with checkmate' do
        board.move('Kxf8')

        board.move('Nbd2')
        expect(board.move('cxd1=Q#')).to eq(true)
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

        expect(board.move('O-O')).to eq(true)
      end

      it 'does not throw error if king or rook does not exist on expected square' do
        board = Board.new

        board.move('e4')
        board.move('e5')

        board.move('Ke2')
        expect(board.move('O-O')).to eq(false)
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
        expect(board.move('O-O-O+')).to eq(true)
      end
    end

    context 'Checkmate' do
      it 'recognizes checkmate' do
        board = Board.new
        board.move('f4')
        board.move('e5')

        board.move('g4')
        expect(board.move('Qh4#')).to eq(true)
        expect(board).to be_over
        expect(board.score).to eq('0-1 Black Wins')
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
        expect(board).to be_over
        expect(board.score).to eq('1-0 White Wins')
      end

      it 'recognizes one more checkmate' do
        #Andreikin, Dmitry vs. Karjakin, Sergey 11/16/2010 Wch Blitz Moscow
        board = Board.new

        board.move('c4')
        board.move('e5')

        board.move('Nc3')
        board.move('Nc6')

        board.move('Nf3')
        board.move('g6')

        board.move('d4')
        board.move('exd4')

        board.move('Nd5')
        board.move('Bg7')

        board.move('Bg5')
        board.move('Nge7')

        board.move('Nxd4')
        board.move('Bxd4')

        board.move('Qxd4')
        board.move('O-O')

        board.move('Nf6+')
        board.move('Kh8')

        expect(board.move('Ng4+')).to eq(true)
        # Could have continued...
        board.move('Nxd4')
        expect(board.move('Bf6+')).to eq(true)
        board.move('Kg8')

        expect(board.move('Nh6#')).to eq(true)
        expect(board).to be_over
        expect(board.score).to eq('1-0 White Wins')
      end
    end

    context 'Stalemate' do
      it 'recognizes stalemate' do
        board = Board.new

        board.move('e3')
        board.move('a5')
  
        board.move('Qh5')
        board.move('Ra6')
  
        board.move('Qxa5')
        board.move('h5')
  
        board.move('h4')
        board.move('Rah6')
  
        board.move('Qxc7')
        board.move('f6')
  
        board.move('Qxd7+')
        board.move('Kf7')
  
        board.move('Qxb7')
        board.move('Qd3')
  
        board.move('Qxb8')
        board.move('Qh7')
  
        board.move('Qxc8')
        board.move('Kg6')
  
        board.move('Qe6')
        expect(board).to be_over
        expect(board.score).to eq('1/2 - 1/2 Stalemate')
      end
    end

    context 'threefold repetition' do
      it 'recognizes threefold repetition in a row' do
        board = Board.new
        board.move('Nf3')
        board.move('Nf6')
        board.move('Ng1')
        board.move('Ng8')
        expect(board).not_to be_over
        board.move('Nf3')
        board.move('Nf6')
        board.move('Ng1')
        board.move('Ng8')
        expect(board).to be_over
        expect(board.score).to eq('1/2 - 1/2 Draw by Threefold Repetition')
      end

      it 'recognizes threefold repetition not in a row' do
        board = Board.new

        board.move('d4')
        board.move('Nc6')

        board.move('Bf4')
        board.move('Nf6')

        board.move('Nc3')
        board.move('Nb8')

        board.move('Nb1')
        board.move('Ng8')

        board.move('Bc1')
        board.move('Nh6')

        board.move('Na3')
        board.move('Ng8')

        expect(board).not_to be_over
        board.move('Nb1')
        expect(board).to be_over
        expect(board.score).to eq('1/2 - 1/2 Draw by Threefold Repetition')
      end
    end

    context 'Fifty move rule' do
      it 'recognizes fifty move rule' do
        board = Board.new

        24.times do
          board.move('Nf3')
          board.move('Nc6')
          board.move('Ng1')
          board.move('Nb8')
        end
        board.move('Nf3')
        board.move('Nc6')
        board.move('Ng1')
        board.move('Nb8')
        expect(board).to be_over
        expect(board.score).to eq('1/2 - 1/2 Fifty Move Rule')
      end
    end

    context 'Insufficient mating material' do
      it 'recognizes insufficient mating material' do
        board = Board.new

        board.move('e4')
        board.move('d5')

        board.move('exd5')
        board.move('Qxd5')

        board.move('Qf3')
        board.move('Qxa2')

        board.move('Qxb7')
        board.move('Qxa1')

        board.move('Qxa8')
        board.move('Qxb2')

        board.move('Qxa7')
        board.move('Qxb1')

        board.move('Qxb8')
        board.move('Qxc2')

        board.move('Qxc7')
        board.move('Qxc1+')

        board.move('Ke2')
        board.move('Qxf1+')

        board.move('Ke3')
        board.move('Qxg2')

        board.move('d4')
        board.move('Qxh2')

        board.move('d5')
        board.move('Qxg1')

        board.move('Rxh7')
        board.move('e6')

        board.move('dxe6')
        board.move('Bc5+')

        board.move('Qxc5')
        board.move('g6')

        board.move('exf7+')
        board.move('Kd7')

        board.move('fxg8=N+')
        board.move('Rxh7')

        board.move('Qg5')
        board.move('Qxf2+')

        board.move('Kxf2')
        board.move('Rh6')

        board.move('Nxh6')
        board.move('Ba6')

        board.move('Qxg6')
        board.move('Bd3')

        board.move('Qf5+')
        board.move('Bxf5')

        expect(board).not_to be_over
        board.move('Nxf5')
        expect(board).to be_over
        expect(board.score).to eq('1/2 - 1/2 Insufficient Mating Material')
      end
    end

    context 'Error messages' do
      board = Board.new

      it 'recognizes invalid input' do
        board.move('Nx5^')
        expect(board.error_message).to eq('Invalid input')
      end

      it 'recognizes invalid promotion' do
        board.move('e4')
        board.move('f5')

        board.move('exf5')
        board.move('g6')

        board.move('fxg6')
        board.move('d5')

        board.move('g7')
        board.move('d4')

        board.move('gxh8')
        expect(board.error_message).to eq('Invalid move (promotion input not valid)')
      end

      it 'recognizes move that ignore check' do
        board.move('gxf8=Q')
        board.move('Bg4')
        expect(board.error_message).to eq('Invalid move (cannot ignore or move into check)')
      end

      it 'recognizes move that result in check' do
        board.move('Kd7')

        board.move('Nf3')
        board.move('Kd6')

        board.move('d3')
        board.move('e5')
        expect(board.error_message).to eq('Invalid move (cannot ignore or move into check)')
      end

      it 'recognizes input with extra characters' do
        board.move('Qxf8+')
        expect(board.error_message).to eq('Invalid move (extra characters)')
      end

      it 'recognizes when no file given for pawn' do
        board.move('xc3')
        expect(board.error_message).to eq(
          'Invalid move (file must be specified for pawn capture)'
        )
      end

      it 'recognizes when pawn move is not possible' do
        board.move('d5')
        expect(board.error_message).to eq('Invalid move (no pawn found to make requested move)')
      end

      it 'recognizes when pawn capture is not possible' do
        board.move('dxf3')
        expect(board.error_message).to eq(
          'Invalid move (no pawn found to make requested capture)'
        )
      end

      it 'recognizes when piece move is not possible' do
        board.move('Ba6')
        expect(board.error_message).to eq(
          'Invalid move (no piece found to make requested move)'
        )
      end

      it 'recognizes when piece capture is not possible' do
        board.move('Qxe7')
        expect(board.error_message).to eq(
          'Invalid capture (no piece found to make requested capture)'
        )
      end

      it 'recognizes when disambiguation is necessary' do
        board.move('Bh3')
        board.move('Nd2')
        expect(board.error_message).to eq('Invalid move (disambiguation required)')
      end

      it 'recognizes when kingside castling not possible' do
        board.move('Be2')
        board.move('Bxg2')

        board.move('O-O')
        expect(board.error_message).to eq('Invalid move (kingside castling not possible)')
      end

      it 'recognizes when queenside castling not possible' do
        board.move('Bf4+')
        board.move('Kd7')

        board.move('Nc3')
        board.move('Nc6')

        board.move('Qd2')
        board.move('Qxf8')

        board.move('O-O-O')
        board.move('Ke8')

        board.move('Nb5')
        board.move('O-O-O')
        expect(board.error_message).to eq('Invalid move (queenside castling not possible)')
      end
    end

    context 'disambiguation' do
      board = Board.new

      it 'requires disambiguation when needed' do
        board.move('Nc3')
        board.move('e5')

        board.move('e4')
        board.move('Bb4')

        expect(board.move('Ne2')).to eq(false)
      end

      it 'works when disambiguation given' do
        expect(board.move('Nge2')).to eq(true)
      end

      it 'does not expect disambiguation if only one legal move' do
        board.move('h5')

        board.move('Ng1')
        board.move('h4')

        board.move('d3')
        board.move('h3')

        expect(board.move('Ne2')).to eq(true)
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
        expect(board.move('O-O-O')).to eq(false)
        expect(board.move('O-O+')).to eq(false)
        expect(board.move('O-O')).to eq(true)
        expect(board.move('O-O')).to eq(false)
        expect(board.move('O-O-O+')).to eq(false)
        expect(board.move('O-O-O')).to eq(true)
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
