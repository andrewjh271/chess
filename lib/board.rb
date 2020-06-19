require_relative 'escape_sequences'
require_relative 'color'
require_relative 'knight'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'


# ♟ ♞ ♝ ♜ ♛ ♚ ♙ ♘ ♗ ♖ ♕ ♔
class Board
  
  include EscapeSequences

  private

  attr_reader :squares

  public

  def initialize
    @squares = []
    8.times { |i| @squares[i] = [] }
    fill_board

  end

  def display
    print_line = Proc.new do |i, file|
      8.times do |j|
        piece = squares[j][file] if file
        print (i + j).even? ?
          "   #{piece || ' '}".bg_cyan + "   ".bg_cyan :
          "   #{piece || ' '}".bg_gray + "   ".bg_gray
      end
      puts
    end
    8.times do |i|
      print_line.call(i)
      print_line.call(i, 7 - i)
      print_line.call(i)
    end
  end

  private

  def fill_board
    squares[0][0] = WhiteRook.new
    squares[7][0] = WhiteRook.new
    squares[1][0] = WhiteKnight.new
    squares[6][0] = WhiteKnight.new
    squares[2][0] = WhiteBishop.new
    squares[5][0] = WhiteBishop.new
    squares[3][0] = WhiteQueen.new
    squares[4][0] = WhiteKing.new
    squares[0][7] = BlackRook.new
    squares[7][7] = BlackRook.new
    squares[1][7] = BlackKnight.new
    squares[6][7] = BlackKnight.new
    squares[2][7] = BlackBishop.new
    squares[5][7] = BlackBishop.new
    squares[3][7] = BlackQueen.new
    squares[4][7] = BlackKing.new
  end

end
