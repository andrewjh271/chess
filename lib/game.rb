require_relative 'board'

class Game
  attr_reader :board, :to_move

  def initialize
    @board = Board.new
    @to_move = 'White'
  end

  def play
    until board.over?
      print "Enter #{to_move}'s move: "
      move = gets.chomp
      next unless board.move(move)

      @to_move = to_move == 'White' ? 'Black' : 'White'
      puts
    end
    puts board.score
  end
end

game = Game.new
game.play