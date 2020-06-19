require_relative 'piece'

class Rook < Piece
  private

  attr_reader :has_moved

  public

  def self.moves(arr)
    file = arr[0]
    rank = arr[1]
    moves = []
    (-7..7).each do |i|
      next if i.zero?

      moves << [file + i, rank]
      moves << [file, rank + i]
    end
    moves
  end

  def initialize(board, location, color)
    super
    @has_moved = false
  end

  def to_s
    white? ? "♖".magenta : "♖".black
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