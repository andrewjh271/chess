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
    until board.over?
      print "Enter #{to_move}'s move: "
      move = gets.chomp
      unless board.move(move)
        move_up(1)
        print_clear
        puts board.error_message.red
        next
      end

      @to_move = to_move == 'White' ? 'Black' : 'White'
      puts
    end
    puts board.score
  end
end

game = Game.new
game.play