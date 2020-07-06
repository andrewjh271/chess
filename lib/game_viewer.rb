# frozen_string_literal: true

require 'pry'
require_relative 'color'
require_relative 'escape_sequences'
require_relative 'board'
require 'io/console'  

# module for viewing games from collections library
module GameViewer
  include EscapeSequences

  CONTROLS = "#{'m'.yellow}ove | #{'p'.green}lay | #{'q'.red}uit"

  def view_game
    game = choose_game
    return unless game
    puts "    Controls: #{CONTROLS}"

    moves = game[1]
    2.times { puts }
    board = Board.new
    move = moves.shift
    board.display(0)
    char = STDIN.getch until %w[m p q].include? char
    return if char == 'q'
    until board.over? || %w[1/2-1/2 1-0 0-1].include?(move) || moves.empty?
      board.move(move)
      board.display(27)
      move = moves.shift
      if char == 'p'
        sleep(1)
      else
        char = STDIN.getch
        char = STDIN.getch until %w[m p q].include? char
      end
      return if char == 'q'
    end
    puts board.score || move
  end

  def choose_game
    collection = get_games
    return unless collection

    show_games(collection)
    begin
      print "Here are the games from this collection. Please choose which you'd like to load: "
      input = gets.chomp
      return if %w[q quit exit].include? input

      game = collection.find { |k, _v| k.match? /^#{input}/ }
      raise "#{input} does not exist.".red unless game
      move_up(2)
      puts_clear
      print game[0]
      game
    rescue StandardError => e
      move_up(2)
      print_clear
      puts e
      retry
    end
  end

  def get_games
    filename = choose_collection
    return unless filename

    file = File.open(File.join(Dir.pwd, filename), 'r'){ |f| f.read }
    # binding.pry
    games = file.split('[Event "')
    games.shift
    regexp = /
      Date\s"                    # scratch
      (?<date>[\d\.\?]+).+         # date
      White\s"                   # scratch
      (?<white>[^,"]+).+         # first player
      Black\s"                   # scratch
      (?<black>[^,"]+)           # second player
      (.+EventDate\s["\w\.\]]+)? # sometimes this is the last line, or sometimes...
      (.+ECO\s["\w\]]+)?         # this
      ([\r\n]+)?                 # different files have different combinations of return chars
      (?<moves>.+)               # moves
    /mx
    games.each_with_object({}).with_index do |(game, hash), index|
      data = game.match(regexp)
      # binding.pry
      player1 = data[:white].cyan
      player2 = data[:black].blue
      date = data[:date]
      hash["#{index + 1}) #{player1} vs #{player2} #{date}"] =
        data[:moves].gsub(/\r\n/, ' ').gsub(/\d+\./, '').split
    end
  end

  def choose_collection
    puts
    puts "Here are the available game collections:"
    puts
    filenames = Dir.glob('collections/*').map{
      |file| file[(file.index('/') + 1)...(file.index('.'))] }
    puts filenames
    puts
    begin
      print "Please choose which you'd like to load: "
      filename = gets.chomp
      return if %w[q quit exit].include? filename

      raise "#{filename} does not exist.".red unless filenames.include?(filename)

      move_up(filenames.length + 5)
      puts_clear
      puts "#{filename} loaded..."
      puts
      "/collections/#{filename}.pgn"
    rescue StandardError => e
      move_up(2)
      print_clear
      puts e
      retry
    end
  end

  def show_games(hash)
    hash.each_key.with_index do |k, i|
      if i < (hash.length / 3.0).ceil
        puts k
      elsif i < (hash.length / 3.0 * 2)
        move_up((hash.length / 3.0).ceil) if i == (hash.length / 3.0).ceil
        move_forward(45)
        puts k
      else
        move_up((hash.length / 3.0).round) if i == (hash.length / 3.0 * 2).ceil
        move_forward(90)
        puts k
      end
    end
    puts unless hash.length % 3 == 0
    puts
  end

end

include GameViewer
view_game