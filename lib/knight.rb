require_relative 'piece'

class Knight < Piece
  def self.moves(arr)
    file = arr[0]
    rank = arr[1]
    moves = []
    (-2..2).each do |i|
      next if i.zero?

      j = i.abs == 2 ? 1 : 2
      moves << [file + i, rank - j]
      moves << [file + i, rank + j]
    end
    moves
  end

  def to_s
    white? ? "♘".magenta : "♘".black
  end
end

class WhiteKnight < Knight
  def initialize
    super('white')
  end
end

class BlackKnight < Knight
  def initialize
    super('black')
  end
end