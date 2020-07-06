# frozen_string_literal: true

require_relative 'board'
require_relative 'escape_sequences'
require_relative 'color'
require_relative 'save_load'

# gameplay
class Game
  include EscapeSequences
  include SaveLoad

  COMMANDS = %w[flip help resign save quit].freeze

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
        COMMANDS.last(3).include?(input) ? break : next
      elsif input == 'draw'
        if draw_accepted?
          board.display
          puts '1/2 - 1/2 Drawn by agreement'.green
          break
        else
          print_info("#{to_move}: Your draw offer was not accepted.".red)
          next
        end
      end
      unless board.move(input)
        print_info("#{board.error_message}: #{input}. Enter help for info.".red)
        next
      end
      @to_move = to_move == 'White' ? 'Black' : 'White'
      board.display
    end
    puts board.score.green if board.score
  end

  def enter_command(input)
    if input == 'flip'
      board.flip_board
    elsif input == 'resign'
      board.display
      if to_move == 'White'
        puts '0-1 Black wins by resignation.'.green
      else
        puts '1-0 White wins by resignation.'.green
      end
    elsif input == 'help'
      print_info('Input moves using Standard Algebraic Notation or enter one of the following: flip | draw | resign | quit | save'.green)
    elsif input == 'save'
      save_game(self)
    end
  end

  def draw_accepted?
    # need to eventually handle if opponent is computer
    move_up(2)
    print_clear
    opponent = to_move == 'White' ? 'Black' : 'White'
    puts "#{opponent}: Your opponent has offered a draw. Do you accept? (Yes/No)".green
    answer = gets[0].downcase
    until %w[y n].include? answer
      move_up(3)
      puts_clear
      puts "Invalid input. #{answer} Do you accept your opponent's draw offer? (Yes/No)".red
      answer = gets[0].downcase
    end
    answer == 'y'
  end

  def print_info(message)
    move_up(2)
    print_clear
    puts message
  end
end
