require_relative 'piece'

class Rook < Piece
  private

  attr_reader :has_moved, :directions

  public

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
    file = location[0]
    rank = location[1]
    directions.each do |direction|
      new_file = file + direction[0]
      new_rank = rank + direction[1]
      while new_file.between?(0, Board::MAX) && 
            new_rank.between?(0, Board::MAX) &&
            board.squares[new_file][new_rank].nil?
        @valid_moves << [new_file, new_rank]
        new_file += direction[0]
        new_rank += direction[1]
      end
    end
  end

  def set_valid_captures
    # does not safeguard against capturing opponents king b/c it cannot be in check
    file = location[0]
    rank = location[1]
    directions.each do |direction|
      new_file = file + direction[0]
      new_rank = rank + direction[1]
      while new_file.between?(0, Board::MAX) && 
            new_rank.between?(0, Board::MAX) &&
            board.squares[new_file][new_rank].nil?
        new_file += direction[0]
        new_rank += direction[1]
      end
      if new_file.between?(0, Board::MAX) && 
         new_rank.between?(0, Board::MAX) &&
         board.squares[new_file][new_rank].white? != white?
        valid_captures << [new_file, new_rank]
      end
    end
  end






  def initialize(board, location, color)
    super
    @has_moved = false
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
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