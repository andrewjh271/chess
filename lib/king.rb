# frozen_string_literal: true

require_relative 'piece'

# Parent class for White and Black Kings
class King < Piece
  private

  attr_reader :in_check, :directions, :moved

  public

  def initialize(board, location, color)
    super
    @in_check = false
    @has_moved = false
    @directions = [-1, 0, 1].repeated_permutation(2).to_a.reject { |arr| arr == [0, 0] }
  end

  def set_valid_moves
    # non-captures
    moves = []
    directions.each do |direction|
      file = location[0] + direction[0]
      rank = location[1] + direction[1]
      next unless file.between?(0, Board::MAX) &&
                  rank.between?(0, Board::MAX) &&
                  board.squares[file][rank].nil?

      moves << [file, rank]
    end
    @valid_moves = moves
  end

  def set_valid_captures
    captures = []
    directions.each do |direction|
      file = location[0] + direction[0]
      rank = location[1] + direction[1]
      next unless file.between?(0, Board::MAX) &&
                  rank.between?(0, Board::MAX) &&
                  board.squares[file][rank] &&
                  board.squares[file][rank].white? != white?

      captures << [file, rank]
    end
    @valid_captures = captures
  end

  def to_s
    white? ? '♚'.gray : '♚'.black
  end

  def in_check? # remove this!
    in_check
  end

  def has_moved?
    moved
  end

  def has_moved
    @moved = true
    @identifier.upcase!
  end
end

# White King
class WhiteKing < King
  def initialize(board, location)
    super(board, location, 'white')
    @identifier = 'a'.dup
  end

  def points(square = location)
    if board.endgame?
      20_000 + WHITE_KING_END[square]
    else
      20_000 + WHITE_KING_MIDDLE[square]
    end
  end
end

# Black King
class BlackKing < King
  def initialize(board, location)
    super(board, location, 'black')
    @identifier = 'b'.dup
  end

  def points(square = location)
    if board.endgame?
      -20_000 - BLACK_KING_END[square]
    else
      -20_000 - BLACK_KING_MIDDLE[square]
    end
  end
end
