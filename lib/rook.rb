require_relative 'piece'
require_relative 'direction_set'

class Rook < Piece
  include DirectionSet

  private

  attr_reader :directions

  public

  attr_accessor :has_moved

  def initialize(board, location, color)
    super
    @has_moved = false
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  end

  # not needed  (I think...)
  def all_moves
    file = location[0]
    rank = location[1]
    moves = []
    (-7..7).each do |i|
      next if i.zero?

      moves << [file + i, rank]
      moves << [file, rank + i]
    end
    moves
  end

  def in_bounds_moves
    all_moves.select { |move| move[0].between?(0, Board::MAX) && move[1].between?(0, Board::MAX) }
  end
  # keeping for now ^

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
    has_moved
  end
end

class WhiteRook < Rook
  def initialize(board, location)
    super(board, location, 'white')
  end
end

class BlackRook < Rook
  def initialize(board, location)
    super(board, location, 'black')
  end
end