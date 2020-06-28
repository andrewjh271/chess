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

        expect(board.move('exf4')).to eq(true)
      end

      it 'allows en passant for black' do
        board.move('d4')

        board.move('c4')
        expect(board.move('dxc4')).to eq(true)
      end

      it 'only allows en passant on first chance' do
        board.move('d4')
        board.move('a5')

        board.move('d5')
        board.move('c5')

        board.move('h4')
        board.move('a4')

        expect(board.move('dxc5')).to eq(false)
      end

      it 'works at edge of board' do
        board.move('b4')
        expect(board.move('axb4')).to eq(true)
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

    end

  end

end