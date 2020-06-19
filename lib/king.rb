require_relative 'piece'

class King < Piece
  def self.moves(arr)
    file = arr[0]
    rank = arr[1]
    moves = []
    [-1, 1].each do |i|
      moves << [file + i, rank]
      moves << [file, rank + i]
      moves << [file + i, rank + i]
      moves << [file + i, rank - i]
    end
    moves
  end

  private

  attr_reader :in_check, :has_moved

  public

  def initialize(color)
    super
    @in_check = false
    @has_moved = false
  end

  def to_s
    white? ? "♔".magenta : "♔".black
  end

  def in_check?
    in_check
  end

  def has_moved?
    has_moved
  end
end

class WhiteKing < King
  def initialize
    super('white')
  end
end

class BlackKing < King
  def initialize
    super('black')
  end
end