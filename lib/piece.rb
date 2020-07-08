# frozen_string_literal: true

# parent class for all pieces
class Piece
  private

  attr_reader :board, :color

  public

  attr_reader :valid_moves, :valid_captures, :identifier, :points
  attr_accessor :location

  def initialize(board, location, color)
    @board = board
    @location = location
    @color = color
    @valid_moves = []
    @valid_captures = []
  end

  def white?
    color == 'white'
  end
end
