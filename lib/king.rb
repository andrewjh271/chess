require_relative 'piece'

class King < Piece
  private

  attr_reader :in_check, :directions

  public

  attr_accessor :has_moved

  def initialize(board, location, color)
    super
    @in_check = false
    @has_moved = false
    @directions = [-1, 0, 1].repeated_permutation(2).to_a.reject { |arr| arr == [0, 0] }
  end

  def set_valid_moves
    # non-captures
    moves = []
    directions.each do |direction|
      file = location[0] + direction[0]
      rank = location[1] + direction[1]
      next unless file.between?(0, Board::MAX) &&
                  rank.between?(0, Board::MAX) &&
                  board.squares[file][rank].nil?

      moves << [file, rank]
    end
    @valid_moves = moves
  end

  def set_valid_captures
    captures = []
    directions.each do |direction|
      file = location[0] + direction[0]
      rank = location[1] + direction[1]
      if file.between?(0, Board::MAX) &&
         rank.between?(0, Board::MAX) &&
         board.squares[file][rank] &&
         board.squares[file][rank].white? != white?
        captures << [file, rank]
      end
    end
    @valid_captures = captures
  end

  def to_s
    white? ? '♚'.gray : '♚'.black
  end

  def in_check?
    in_check
  end

  def has_moved?
    has_moved
  end
end

class WhiteKing < King
  def initialize(board, location)
    super(board, location, 'white')
  end
end

class BlackKing < King
  def initialize(board, location)
    super(board, location, 'black')
  end
end