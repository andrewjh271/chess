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
    Would you like to: 1) Start a new game
                       2) Load a game
                       3) View a game from the collection library
  HEREDOC

  puts prompt

  user_choice = gets.chomp
  move_up(5)
  puts_clear

  until %w[1 2 3].include?(user_choice)
    puts 'Invalid input. Please enter 1, 2, or 3.'
    user_choice = gets.chomp
  end

  # if user_choice == '3'
  #   view_game
  # else
  #   game = user_choice == '1' ? Game.new : load_game
  #   2.times { puts }
  #   game.play
  # end

  if user_choice == '1'
    game = Game.new(Computer.new('White'), Computer.new('Black'))
    2.times { puts }
    game.play
  elsif user_choice == '2'
    game = load_game
    2.times { puts }
    game.play
  else
    view_game
  end


  puts
end

