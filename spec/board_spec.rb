require './lib/board.rb'

describe Board do
  
  describe '#in_check?' do
    board = Board.new
    board.move('e4')
    board.move('e5')
    board.move('Bc4')
    board.move('Bc5')

    it { expect(board).not_to be_in_check }

    it "returns true if current side's king is in check" do
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
    # check
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

    # en passant
    board2 = Board.new

    it 'allows en passant for white' do
      board2.move('e4')
      board2.move('d5')

      board2.move('e5')
      board2.move('f5')

      expect(board2.move('exf4')).to eq(true)
    end

    it 'allows en passant for black' do
      board2.move('d4')

      board2.move('c4')
      expect(board2.move('dxc4')).to eq(true)
    end

    it 'only allows en passant on first chance' do
      board2.move('d4')
      board2.move('a5')

      board2.move('d5')
      board2.move('c5')

      board2.move('h4')
      board2.move('a4')

      expect(board2.move('dxc5')).to eq(false)
    end

    it 'works at edge of board' do
      board2.move('b4')
      expect(board2.move('axb4')).to eq(true)
    end

    # promotion
    board3 = Board.new
    
    it 'allows capture promotion to WhiteKnight' do
      board3.move('d4')
      board3.move('e5')

      board3.move('dxe5')
      board3.move('f6')

      board3.move('exf6')
      board3.move('d5')

      board3.move('fxg7')
      board3.move('d4')

      board3.move('gxh8=N')
      expect(board3.squares[7][7].is_a?(WhiteKnight)).to eq(true)
    end

    it 'allows promotion to BlackQueen' do
      board3.move('d3')

      board3.move('Bg5')
      board3.move('dxc2')

      board3.move('Nf3')
      board3.move('c1=Q')
      expect(board3.squares[2][0].is_a?(BlackQueen)).to eq(true)
    end

  end

end