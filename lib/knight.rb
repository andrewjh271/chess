# frozen_string_literal: true

require_relative 'piece'

# Parent class for White and Black Knights
class Knight < Piece
  def all_moves
    # including those that go off board
    file = location[0]
    rank = location[1]
    moves = []
    (-2..2).each do |i|
      next if i.zero?

      j = i.abs == 2 ? 1 : 2
      moves << [file + i, rank - j]
      moves << [file + i, rank + j]
    end
    moves
  end

  def in_bounds_moves
    all_moves.select { |move| move[0].between?(0, Board::MAX) && move[1].between?(0, Board::MAX) }
  end

  def set_valid_moves
    # (non-captures)
    @valid_moves = in_bounds_moves.reject do |move|
      board.squares[move[0]][move[1]]
    end
  end

  def set_valid_captures
    # does not safeguard against capturing opponents king b/c it cannot be in check
    @valid_captures = in_bounds_moves.reject do |move|
      board.squares[move[0]][move[1]].nil? ||
        board.squares[move[0]][move[1]].white? == white?
    end
  end

  def to_s
    white? ? '♞'.gray : '♞'.black
  end
end

# White Knight
class WhiteKnight < Knight
  def initialize(board, location)
    super(board, location, 'white')
    @identifier = 'i'
  end

  def points(square = location)
    320 + WHITE_KNIGHT_TABLE[square]
  end
end

# Black Knight
class BlackKnight < Knight
  def initialize(board, location)
    super(board, location, 'black')
    @identifier = 'j'
  end

  def points(square = location)
    # I kept the postive/negative values the same b/c white/black tables were so similar
    -320 - BLACK_KNIGHT_TABLE[square]
  end
end
