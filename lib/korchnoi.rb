require 'pry'

# used as opening database
module Korchnoi
  def load_openings
    file = File.open(File.join(Dir.pwd, '/openings/Korchnoi.pgn'), &:read)
    games = file.split('[Event "')
    games.shift # get rid of empty value at beginning
    regexp = /
      \r\n\r\n
      (?<moves>.+)
    /mx
    moves = games.each_with_object([]) do |game, array|
      data = game.match(regexp)
      list = data[:moves].gsub(/\r\n/, ' ').gsub(/\d+\./, '').split
      # don't include result
      array << list.take(list.length - 1)
    end
    # binding.pry
    moves
  end

  def find_match(move_list)
    moves = move_list.join.split.reject { |move| move.match?(/\./) }
    load_openings.each do |game|
      if game.take(moves.length) == moves
        return game[moves.length]
      end
    end
    false
  end
end

include Korchnoi


# load_openings


move_list =  ["1.  Nc3     Nf6     ", "2.  Nf3     Nc6     ", "3.  e3      e6      ", "4.  Bb5     Bb4     "]

move_list2 = %w[1.c4 Nf6 2.d4        e6 3.Nc3 Bb4      4.e3 c5     5.Ne2          d5]

move_list3 = []

p find_match(move_list3)