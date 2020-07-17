# frozen_string_literal: true

require_relative 'color'
require_relative 'escape_sequences'
require_relative 'board'
require 'io/console'

# module for viewing games from collections library
module GameViewer
  include EscapeSequences

  CONTROLS = "#{'m'.yellow}ove | #{'p'.green}lay | #{'z'.magenta}oom | #{'q'.red}uit"

  def view_game
    game = select_game
    return unless game

    hide_cursor
    moves = game[1]
    puts "    Controls: #{CONTROLS}"
    2.times { puts }
    board = Board.new
    board.display(0)
    char = nil
    loop do
      if char == 'p'
        sleep(2)
      elsif char == 'z'
        sleep(0.2)
      else
        char = STDIN.getch
        char = STDIN.getch until %w[m p z q].include? char

        if char == 'q'
          show_cursor
          return
        end
      end
      move = moves.shift
      unless board.move(move)
        puts "#{board.error_message}: #{move}. Ending game...".red
        return
      end
      board.display(27) # move up 1 fewer line than in game mode
      break if board.over? || %w[1/2-1/2 1-0 0-1].include?(moves.first) || moves.empty?
    end
    if board.score
      puts board.score
    else
      puts case moves.first
           when '1-0' then '1 - 0 White wins by resignation'.green
           when '0-1' then '0 - 1 Black wins by resignation'.green
           when '1/2-1/2' then '1/2 - 1/2 Drawn by agreement'.green
           else 'Result not found'.red
           end
    end
    show_cursor
  end

  def select_game
    collection = load_games
    return unless collection

    show_games(collection)
    begin
      print "Here are the games from this collection. Please choose which you'd like to load: "
      input = gets.chomp
      return if %w[q quit exit].include? input

      game = collection.find { |k, _v| k.match?(/^#{Regexp.quote(input)}/) }
      move_up(2)
      raise "#{input} does not exist.".red unless game

      puts_clear
      print game[0]
      game
    rescue StandardError => e
      print_clear
      puts e
      retry
    end
  end

  def load_games
    filename = choose_collection
    return unless filename

    file = File.open(File.join(Dir.pwd, filename), &:read)
    games = file.split('[Event "')
    games.shift # get rid of empty value at beginning
    regexp = /
      Date\s"                    # comes before date
      (?<date>[\d\.\?]+).+       # date
      White\s"                   # comes before first player
      (?<white>[^,"]+).+         # first player
      Black\s"                   # comes before second player
      (?<black>[^,"]+)           # second player
      (.+EventDate\s["\w\.\]]+)? # game info ends with either this line...
      (.+ECO\s["\w\]]+)?         # or this line
      ([\r\n]+)?                 # different files have different combinations of line break chars
      (?<moves>.+)               # moves
    /mx
    games.each_with_object({}).with_index do |(game, hash), index|
      data = game.match(regexp)
      player1 = data[:white].cyan
      player2 = data[:black].blue
      date = data[:date]
      hash["#{index + 1}) #{player1} vs #{player2} #{date}"] =
        data[:moves].gsub(/\r\n/, ' ').gsub(/\d+\./, '').split
    end
  end

  def choose_collection
    puts 'Here are the available game collections:'
    puts
    filenames = Dir.glob('collections/*').map.with_index do |file, index|
      "#{index + 1}) #{file[(file.index('/') + 1)...(file.index('.'))]}"
    end
    puts filenames
    puts
    begin
      print "Please choose which you'd like to load: "
      input = gets.chomp
      return if %w[q quit exit].include?(input)

      filename = filenames.find { |f| f.match?(/^#{Regexp.quote(input)}/) }.dup
      raise "#{input} does not exist.".red unless filename

      filename.slice!(/\d\) /)
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

  # added complication in order to make 3 descending columns
  def show_games(hash)
    hash.each_key.with_index do |k, i|
      if i < (hash.length / 3.0).ceil
        # do nothing
      elsif i < (hash.length / 3.0 * 2)
        move_up((hash.length / 3.0).ceil) if i == (hash.length / 3.0).ceil
        move_forward(45)
      else
        move_up((hash.length / 3.0).round) if i == (hash.length / 3.0 * 2).ceil
        move_forward(90)
      end
      puts k
    end
    puts unless (hash.length % 3).zero?
    puts
  end
end
