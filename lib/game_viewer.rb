require 'pry'

module GameViewer
  def generate_key
    dictionary = File.open('5desk.txt', 'r')
    words = []
    dictionary.each_line do |l|
      l = l.chomp
      if l.length <= 12 &&
         l.length >= 5 &&
         /[[:lower:]]/.match(l[0])
        words << l
      end
    end
    dictionary.close
    words.sample
  end

  def get_games
    file = File.open(File.join(Dir.pwd, "/collections/WijkaanZee2020.pgn"), 'r')
    tournament = file.read
    games = tournament.split('[Event "')
    games.shift

    # data = games[2].match(/Date "(?<date>[\d\.]+).+White "(?<white>[^,"]+).+Black "(?<black>[^,"]+).+\r\n\r\n(?<moves>.+)/m)

    regexp = /
      Date\s"                    # scratch
      (?<date>[\d\.]+).+         # date
      White\s"                   # scratch
      (?<white>[^,"]+).+         # first player
      Black\s"                   # scratch
      (?<black>[^,"]+).+\r\n\r\n # second player
      (?<moves>.+)               # moves
    /mx
    data = games[2].match(regexp)
    
    
    moves = data[:moves].gsub(/\r\n/, ' ').gsub(/\d+\./, '').split
    
    games_hash = games.each_with_object({}).with_index do |(game, hash), index|
      data = game.match(regexp)
      player1 = data[:white].downcase.gsub(' ', '_')
      player2 = data[:black].downcase.gsub(' ', '_')
      date = data[:date].gsub('.', '-')
      hash["#{index + 1})#{player1}-#{player2}-#{date}"] = data[:moves]
    end



    binding.pry
  end

end

include GameViewer
get_games