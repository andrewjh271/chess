# frozen_string_literal: true

require 'yaml'
require_relative 'color'

# Handles saving and loading games
module SaveLoad
  def save_game(current_game)
    filename = prompt_name
    return false unless filename

    dump = YAML.dump(current_game)
    File.open(File.join(Dir.pwd, "/saved/#{filename}.yaml"), 'w') { |file| file.write dump }
  end

  def prompt_name
    begin
      filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
      puts 'Enter name for saved game'
      filename = gets.chomp
      raise "#{filename} already exists." if filenames.include?(filename)

      filename
    rescue StandardError => e
      puts "#{e} Are you sure you want to rewrite the file? (Yes/No)".red
      answer = gets[0].downcase
      until %w[y n].include? answer
        puts "Invalid input. #{e} Are you sure you want to rewrite the file? (Yes/No)".red
        answer = gets[0].downcase
      end
      return filename if answer == 'y'

      puts 'Do you want to try again? (Yes/No)'.red
      answer = gets[0].downcase
      retry if answer == 'y'
    end
  end

  def load_game
    filename = choose_game
    saved = File.open(File.join(Dir.pwd, filename), 'r')
    loaded_game = YAML.load(saved)
    saved.close
    loaded_game
  end

  def choose_game
    begin
      puts "Here are the current saved games. Please choose which you'd like to load."
      filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
      puts filenames
      filename = gets.chomp
      raise "#{filename} does not exist.".red unless filenames.include?(filename)

      puts "#{filename} loaded..."
      puts
      "/saved/#{filename}.yaml"
    rescue StandardError => e
      puts e
      retry
    end
  end
end
