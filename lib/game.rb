require_relative 'board'
require_relative 'escape_sequences'
require_relative 'color'
require_relative 'save_load'

class Game
  include EscapeSequences
  include SaveLoad

  COMMANDS = ['flip', 'quit', 'help', 'save']

  attr_reader :board, :to_move

  def initialize
    @board = Board.new
    @to_move = 'White'
  end

  def play
    board.display(0)
    until board.over?
      print "Enter #{to_move}'s move: "
      input = gets.chomp
      if COMMANDS.include?(input)
        enter_command(input)
        input == 'quit' ? break : next
      end
      unless board.move(input)
        print_info("#{board.error_message} Enter help for help.".red)
        next
      end
      @to_move = to_move == 'White' ? 'Black' : 'White'
      board.display
    end
    puts board.score
  end

  def enter_command(input)
    if input == 'flip'
      board.flip_board
    elsif input == 'help'
      print_info('Input moves using Chess Algebraic Notation, or enter one of the following commands: flip | quit | save'.green)
    elsif input == 'save'
      save_game(self)
    end
  end

  def print_info(message)
    move_up(2)
    print_clear
    puts message
  end
end