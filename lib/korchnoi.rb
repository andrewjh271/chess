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
    games.each_with_object([]) do |game, array|
      data = game.match(regexp)
      array << data[:moves].gsub(/\r\n/, ' ').gsub(/\d+\./, '').split
    end.shuffle
  end

  def find_match(move_list)
    moves = move_list.join.split.reject { |move| move.match?(/\./) }
    load_openings.each do |game|
      return game[moves.length] if game.take(moves.length) == moves
    end
    false
  end
end
