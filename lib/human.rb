class Human
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def to_s
    color
  end
end
