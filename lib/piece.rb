class Piece
  
  private 
  
  attr_reader :board, :location, :color

  public

  attr_reader :valid_moves, :valid_captures

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