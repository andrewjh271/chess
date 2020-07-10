require_relative 'board'
require_relative 'color'
require 'pry'

class Computer
  attr_reader :color, :board

  def initialize(color)
    @color = color
    @board = board
  end

  def to_s
    color
  end

  def white?
    color == 'White'
  end

  def set_board(board)
    @board = board
  end

  def move
    # move_info = board.find_valid_move
    # input = get_input(move_info)
    # puts "Computer move: #{input}"
    # sleep(1)
    # board.move(input)

    # moves = board.find_valid_moves
    # board.move(moves.first)
    print "Calculating computer's move... ".yellow
    move = board.choose_move
    puts move
    # sleep(1)
    board.move(move)
  end

end