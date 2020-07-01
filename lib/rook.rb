require_relative 'piece'
require_relative 'direction_set'

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
    white? ? "♜".gray : "♜".black
  end

  def has_moved?
    moved
  end

  def has_moved
    @moved = true
    @identifier.upcase!
  end
end

class WhiteRook < Rook
  def initialize(board, location)
    super(board, location, 'white')
    @identifier = 'e'
  end
end

class BlackRook < Rook
  def initialize(board, location)
    super(board, location, 'black')
    @identifier = 'f'
  end
end