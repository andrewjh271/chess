# frozen_string_literal: true

require_relative 'piece_square_tables'

# parent class for all pieces
class Piece
  include Piece_Square_Tables

  private

  attr_reader :board, :color

  public

  attr_reader :valid_moves, :valid_captures, :identifier
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

