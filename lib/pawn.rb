# frozen_string_literal: true

require_relative 'piece'

# parent class for White and Black Pawns
class Pawn < Piece
  private

  attr_reader :color, :moved

  public

  attr_accessor :en_passant, :en_passant_capture

  def initialize(board, location, color)
    super
    @moved = false
  end

  def to_s
    white? ? '♟'.gray : '♟'.black
  end

  def set_valid_moves(dir)
    moves = []
    file = location[0]
    rank = location[1] + 1 * dir
    unless has_moved?
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

  def has_moved?
    moved
  end

  def has_moved
    @moved = true
  end
end

# White Pawn
class WhitePawn < Pawn
  def initialize(board, location)
    super(board, location, 'white')
    @identifier = 'k'.dup
  end

  def points(square = location)
    100 + WHITE_PAWN_TABLE[square]
  end

  def set_valid_moves
    super(1)
  end

  def set_valid_captures
    super(1)
  end

  def add_en_passant(file)
    @en_passant = [file, 5]
    @en_passant_capture = [file, 4]
    @identifier.upcase!
  end

  def remove_en_passant
    @en_passant = nil
    @identifier.downcase!
  end
end

# Black Pawn
class BlackPawn < Pawn
  def initialize(board, location)
    super(board, location, 'black')
    @identifier = 'l'.dup
  end

  def points(square = location)
    -100 + BLACK_PAWN_TABLE[square]
  end

  def set_valid_moves
    super(-1)
  end

  def set_valid_captures
    super(-1)
  end

  def add_en_passant(file)
    @en_passant = [file, 2]
    @en_passant_capture = [file, 3]
  end

  def remove_en_passant
    @en_passant = nil
  end
end
