# frozen_string_literal: true

require_relative 'board'
require_relative 'escape_sequences'
require_relative 'color'
require_relative 'save_load'
require_relative 'instructions'
require_relative 'human'
require_relative 'computer'
require 'io/console'

# gameplay
class Game
  include EscapeSequences
  include SaveLoad
  include Instructions

  # omits 'draw' b/c it is not known whether game should end
  COMMANDS = %w[flip help resign save quit exit tutorial].freeze

  attr_reader :board, :to_move, :white, :black

  def initialize(white, black)
    @board = Board.new
    @white = white
    @white.set_board(board) if white.is_a?(Computer)
    @black = black
    @black.set_board(board) if black.is_a?(Computer)
    board.flip_board(false) if white.is_a?(Computer) && black.is_a?(Human)
    @to_move = white
  end

  def play
    board.display(0)
    until board.over?
      if to_move.is_a?(Human)
        print "Enter #{to_move}'s move: "
        input = gets.chomp
        if COMMANDS.include?(input)
          enter_command(input)
          %w[quit exit save resign].include?(input) ? break : next
        elsif input == 'draw'
          if draw_accepted?
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
      else
        to_move.move
      end
      @to_move = to_move == white ? black : white
      board.display
    end
    puts if board.over?
    board.display
    puts board.move_list
    puts
    puts board.score.green if board.score
  end

  def enter_command(input)
    if input == 'flip'
      board.flip_board
    elsif input == 'resign'
      board.display
      if to_move == 'White'
        puts '0-1 Black wins by resignation'.green
      else
        puts '1-0 White wins by resignation'.green
      end
    elsif input == 'help'
      print_info('Input move or enter a command: flip | draw | resign | quit | save | tutorial'.green)
    elsif input == 'save'
      save_game(self)
    elsif input == 'tutorial'
      show_instructions
      clear_board
      board.display
      show_cursor
    end
  end

  def draw_accepted?
    opponent = to_move == white ? black : white
    return false if opponent.is_a?(Computer)

    move_up(2)
    print_clear
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
