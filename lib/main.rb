require_relative 'game'
require_relative 'save_load'

class Main
  extend SaveLoad

  prompt = <<~HEREDOC
    Chess. Would you like to: 1) Start a new game
                              2) Load a game
    HEREDOC
  puts prompt

  user_choice = gets.chomp
  puts
  until ['1', '2'].include?(user_choice)
    puts "Invalid input. Please enter 1 or 2"
    user_choice = gets.chomp
  end

  game  = user_choice == '1' ? Game.new : load_game
  2.times { puts }
  game.play
end
