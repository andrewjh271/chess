require_relative 'piece'

class Queen < Piece
  def self.moves(arr)
    file = arr[0]
    rank = arr[1]
    moves = []
    (-7..7).each do |i|
      next if i.zero?

      moves << [file + i, rank]
      moves << [file, rank + i]
      moves << [file + i, rank + i]
      moves << [file + i, rank - i]
    end
    moves
  end

  def to_s
    white? ? '♕'.magenta : '♕'.black
  end
end

class WhiteQueen < Queen
  def initialize(board, location)
    super(board, location, 'white')
  end
end

class BlackQueen < Queen
  def initialize(board, location)
    super(board, location, 'black')
  end
end