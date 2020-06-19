class Pawn < Piece
  private

  attr_reader :color

  public

  def initialize(board, location, color)
    super
    @has_moved = false
  end

  def to_s
    white? ? '♙'.magenta : '♙'.black
  end

  def has_moved?
    has_moved
  end
end

class WhitePawn < Pawn
  def self.moves(arr)

  end

  def self.captures(arr)

  end

  def initialize(board, location)
    super(board, location, 'white')
  end
end

class BlackPawn < Pawn
  def self.moves(arr)

  end

  def self.captures(arr)

  end

  def initialize(board, location)
    super(board, location, 'black')
  end
end