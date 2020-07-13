require_relative 'board'
require_relative 'color'
require 'pry'

class Computer
  attr_reader :color, :board, :in_book

  def initialize(color)
    @color = color
    @board = board
    @in_book = true
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
    book_move = book if in_book

    if in_book
      book_animation(book_move)
      board.move(book_move)
    else
      print "Calculating computer's move... ".yellow
      move = board.choose_move(3)
      puts move
      sleep(0.5)
      board.move(move)
    end
  end

  def book
    copy = Marshal.load(Marshal.dump(board))
    book_move = board.find_book_move
    return book_move if book_move && copy.move(book_move)
  
    @in_book = false
  end

  def book_animation(the_move)
    print 'Opening book'.yellow
    5.times do
      sleep(0.1)
      print '.'.yellow
    end
    print ' '
    puts the_move
    sleep(0.5)
  end
end
