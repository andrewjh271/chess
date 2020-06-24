require_relative 'piece'
require_relative 'direction_set'

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
    white? ? "♝".gray : "♝".black
  end
end

class WhiteBishop < Bishop
  def initialize(board, location)
    super(board, location, 'white')
  end
end

class BlackBishop < Bishop
  def initialize(board, location)
    super(board, location, 'black')
  end
end