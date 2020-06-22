require_relative 'piece'
require 'pry'

class Pawn < Piece
  private

  attr_reader :color

  public

  attr_accessor :has_moved

  def initialize(board, location, color)
    super
    @has_moved = false
  end

  def to_s
    white? ? '♙'.magenta : '♙'.black
  end

  def set_valid_moves(dir)
    moves = []
    file = location[0]
    rank = location[1] + 1 * dir
    unless has_moved
      moves << [file, rank + 1 * dir] if board.squares[file][rank + 1 * dir].nil? &&
                                         board.squares[file][rank].nil?
    end
    moves << [file, rank] if rank.between?(0, Board::MAX) && board.squares[file][rank].nil?
    @valid_moves = moves
  end

  def set_valid_captures(dir)
    captures = []
    file = location[0] - 1
    rank = location[1] + 1 * dir
    if rank.between?(0, Board::MAX)
      captures << [file, rank] if file.between?(0, Board::MAX) && board.squares[file][rank] &&
                                  board.squares[file][rank].white? != white?
      file = location[0] + 1
      captures << [file, rank] if file.between?(0, Board::MAX) && board.squares[file][rank] &&
                                  board.squares[file][rank].white? != white?
    end
    @valid_captures = captures
  end
end

class WhitePawn < Pawn
  def initialize(board, location)
    super(board, location, 'white')
  end

  def set_valid_moves
    super(1)
  end

  def set_valid_captures
    super(1)
  end
end

class BlackPawn < Pawn
  def initialize(board, location)
    super(board, location, 'black')
  end

  def set_valid_moves
    super(-1)
  end

  def set_valid_captures
    super(-1)
  end
end