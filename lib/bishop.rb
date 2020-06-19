require_relative 'piece'

class Bishop < Piece
  def self.moves(arr)
    file = arr[0]
    rank = arr[1]
    moves = []
    (-7..7).each do |i|
      next if i.zero?

      moves << [file + i, rank + i]
      moves << [file + i, rank - i]
    end
    moves
  end

  def to_s
    white? ? "♗".magenta : "♗".black
  end
end

class WhiteBishop < Bishop
  def initialize
    super('white')
  end
end

class BlackBishop < Bishop
  def initialize
    super('black')
  end
end