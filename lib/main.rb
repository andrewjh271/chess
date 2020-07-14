# frozen_string_literal: true

require_relative 'game'
require_relative 'save_load'
require_relative 'escape_sequences'
require_relative 'game_viewer'

# driver script for chess application
class Main
  extend SaveLoad
  extend EscapeSequences
  extend GameViewer

  prompt = <<~HEREDOC

    #{'Chess!'.green}
    Would you like to: 1) Human vs Human
                       2) Human vs Computer
                       3) Computer vs Human
                       4) Computer vs Computer
                       5) Load a game
                       6) View a game from the collection library
  HEREDOC

  puts prompt

  user_choice = gets.chomp
  move_up(8)
  puts_clear

  until %w[1 2 3 4 5 6].include?(user_choice)
    puts 'Invalid input. Please enter 1, 2, 3, 4, 5, or 6.'
    user_choice = gets.chomp
  end

  if user_choice.to_i < 5
    white = %w[1 2].include?(user_choice) ? Human.new('White') : Computer.new('White')
    black = %w[2 4].include?(user_choice) ? Computer.new('Black') : Human.new('Black')
    game = Game.new(white, black)
    2.times { puts }
    game.play
  elsif user_choice == '5'
    game = load_game
    2.times { puts }
    game.play
  else
    view_game
  end
  puts
end

