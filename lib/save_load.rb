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
    return unless filename

    saved = File.open(File.join(Dir.pwd, filename), 'r')
    loaded_game = YAML.load(saved)
    saved.close
    loaded_game
  end

  def choose_game
    puts "Here are the current saved games. Please choose which you'd like to load: "
    filenames = Dir.glob('saved/*').map.with_index do |file, index|
      "#{index + 1}) #{file[(file.index('/') + 1)...(file.index('.'))]}"
    end
    puts filenames
    puts
    begin
      input = gets.chomp
      return if %w[q quit exit].include?(input)

      filename = filenames.find { |f| f.match?(/^#{Regexp.quote(input)}/) }.dup
      raise "#{input} does not exist.".red unless filename

      filename.slice!(/\d\) /)
      (filenames.length + 3).times do
        move_up(1)
        print_clear
      end
      puts "#{filename} loaded..."
      puts
      "/saved/#{filename}.yaml"
    rescue StandardError => e
      move_up(2)
      print_clear
      puts e
      retry
    end
  end
end
