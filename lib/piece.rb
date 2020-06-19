class Piece
  
  private 
  
  attr_reader :color

  public

  def initialize(color)
    @color = color
  end

  def white?
    color == 'white'
  end
end