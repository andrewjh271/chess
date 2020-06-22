require_relative 'escape_sequences'
require_relative 'color'
require_relative 'knight'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
require 'pry'

# ♟ ♞ ♝ ♜ ♛ ♚ ♙ ♘ ♗ ♖ ♕ ♔
class Board
  
  include EscapeSequences

  attr_reader :squares, :white_to_move
  
  MAX = 7

  def initialize
    @squares = []
    @white_to_move = true
    8.times { |i| @squares[i] = [] }
    fill_board
    set_moves_and_captures
  end

  def display
    print_line = Proc.new do |i, rank|
      8.times do |j|
        piece = squares[j][rank] if rank
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

  def each_piece
    squares.each do |rank|
      rank.each do |square|
        square ? (yield square) : next
      end
    end
  end

  def move(notation)
    # origionally /[KQRBN]|[a-h]x/
    target_piece = case notation.slice!(/[KQRBN]/)
            when 'K' then white_to_move ? WhiteKing : BlackKing
            when 'Q' then white_to_move ? WhiteQueen : BlackQueen
            when 'R' then white_to_move ? WhiteRook : BlackRook
            when 'B' then white_to_move ? WhiteBishop : BlackBishop
            when 'N' then white_to_move ? WhiteKnight : BlackKnight
            # when /[a-h]x/ then white_to_move ? WhitePawn : BlackPawn
            else white_to_move ? WhitePawn : BlackPawn
            end
    target = to_coords(notation.slice!(/[a-h][1-8]/))
    action = notation.slice!('x') ? 'capture' : 'move'
    candidates = []
    each_piece do |piece|
      if action == 'capture'
        candidates << piece if piece.valid_captures.include? target && piece.is_a?(target_piece)
      else
        candidates << piece if piece.is_a?(target_piece) && piece.valid_moves.include?(target)
      end
    end
    p notation
    p target_piece
    p target
    candidates.each { |c| puts "#{c}-#{to_alg(c.location)} "}
    puts
  end

  private

  def fill_board
    squares[0][0] = WhiteRook.new(self, [0, 0])
    squares[7][0] = WhiteRook.new(self, [7, 0])
    squares[1][0] = WhiteKnight.new(self, [1, 0])
    squares[6][0] = WhiteKnight.new(self, [6, 0])
    squares[2][0] = WhiteBishop.new(self, [2, 0])
    squares[5][0] = WhiteBishop.new(self, [5, 0])
    squares[3][0] = WhiteQueen.new(self, [3, 0])
    squares[4][0] = WhiteKing.new(self, [4, 0])
    8.times { |i| squares[i][1] = WhitePawn.new(self, [i, 1]) }
    squares[0][7] = BlackRook.new(self, [0, 7])
    squares[7][7] = BlackRook.new(self, [7, 7])
    squares[1][7] = BlackKnight.new(self, [1, 7])
    squares[6][7] = BlackKnight.new(self, [6, 7])
    squares[2][7] = BlackBishop.new(self, [2, 7])
    squares[5][7] = BlackBishop.new(self, [5, 7])
    squares[3][7] = BlackQueen.new(self, [3, 7])
    squares[4][7] = BlackKing.new(self, [4, 7])
    8.times { |i| squares[i][6] = BlackPawn.new(self, [i, 6]) }
  end

  def set_moves_and_captures
    each_piece do |piece|
      piece.set_valid_moves
      piece.set_valid_captures
    end
  end

  def to_coords(notation)
    [notation[0].ord - 97, notation[1].to_i - 1]
  end

  def to_alg(coordinates)
    (coordinates[0] + 97).chr + (coordinates[1] + 1).to_s
  end

end
