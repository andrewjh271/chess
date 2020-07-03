require_relative 'board'
require_relative 'escape_sequences'
require_relative 'color'

class Game
  include EscapeSequences

  attr_reader :board, :to_move

  def initialize
    @board = Board.new
    @to_move = 'White'
  end

  def play
    board.display(0)
    until board.over?
      print "Enter #{to_move}'s move: "
      move = gets.chomp
      if move == 'flip'
        board.flip_board
        next
      elsif move == 'quit'
        break
      end
      unless board.move(move)
        move_up(2)
        print_clear
        puts board.error_message.red
        next
      end

      @to_move = to_move == 'White' ? 'Black' : 'White'
      board.display
    end
    puts board.score
  end
end

2.times { puts }
game = Game.new
game.play