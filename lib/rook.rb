require_relative 'piece'

class Rook < Piece
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

  private

  attr_reader :has_moved

  public

  def initialize(color)
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
  def initialize
    super('white')
  end
end

class BlackRook < Rook
  def initialize
    super('black')
  end
end