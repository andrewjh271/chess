class Piece
  
  private 
  
  attr_reader :board, :color
  # :location

  public

  attr_reader :valid_moves, :valid_captures
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