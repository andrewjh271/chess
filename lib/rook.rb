# frozen_string_literal: true

require_relative 'piece'
require_relative 'direction_set'

# Parent class for White and Black Rooks
class Rook < Piece
  include DirectionSet

  private

  attr_reader :directions, :moved

  public

  def initialize(board, location, color)
    super
    @has_moved = false
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  end

  def set_valid_moves
    # non-captures
    @valid_moves = find_valid_moves(directions)
  end

  def set_valid_captures
    # does not safeguard against capturing opponents king b/c it cannot be in check
    @valid_captures = find_valid_captures(directions)
  end

  def to_s
    white? ? '♜'.gray : '♜'.black
  end

  def has_moved?
    moved
  end

  def has_moved
    @moved = true
    @identifier.upcase!
  end
end

# White Rook
class WhiteRook < Rook
  def initialize(board, location)
    super(board, location, 'white')
    @identifier = 'e'.dup
  end

  def points(square = location)
    500 + WHITE_ROOK_TABLE[square]
  end
end

# Black Rook
class BlackRook < Rook
  def initialize(board, location)
    super(board, location, 'black')
    @identifier = 'f'.dup
  end

  def points(square = location)
     # I kept the postive/negative values the same b/c white/black tables were so similar
    -500 - BLACK_ROOK_TABLE[square]
  end
end
