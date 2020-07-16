require_relative 'board'
require_relative 'color'
require_relative 'korchnoi'
require_relative 'escape_sequences'

class Computer
  include Korchnoi
  include EscapeSequences

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
    hide_cursor
    if (book_move = find_book_move)
      book_animation(book_move)
      board.move(book_move)
    else
      puts "Calculating computer's move...".yellow
      move = board.choose_move(4)
      board.move(move)
    end
    show_cursor
  end

  def find_book_move
    book_move = find_match(board.move_list)
    if book_move
      copy = Marshal.load(Marshal.dump(board))
      return book_move if copy.move(book_move)
    end
    false
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
