# frozen_string_literal: true

require_relative 'piece'
require_relative 'direction_set'

# Parent class for Bishops
class Bishop < Piece
  include DirectionSet

  private

  attr_reader :directions

  public

  def initialize(board, location, color)
    super
    @directions = [-1, 1].repeated_permutation(2).to_a
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
    white? ? '♝'.gray : '♝'.black
  end

  def dark_squared?
    (location[0] + location[1]).even?
  end
end

# White Bishop
class WhiteBishop < Bishop
  def initialize(board, location)
    super(board, location, 'white')
    @identifier = 'g'
  end

  def points(square = location)
    330 + WHITE_BISHOP_TABLE[square]
  end
end

# Black Bishop
class BlackBishop < Bishop
  def initialize(board, location)
    super(board, location, 'black')
    @identifier = 'h'
  end

  def points(square = location)
    -330 + BLACK_BISHOP_TABLE[square]
  end
end
