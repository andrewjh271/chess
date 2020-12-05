# methods for Board class to allow engine logic
module Engine

  MIN = -99_999
  MAX = 99_999

  def find_valid_moves
    all = []
    en_passants = []
    each_piece do |piece|
      next unless piece.white? == white_to_move

      piece.valid_captures.each do |capture|
        value = squares[capture[0]][capture[1]].points.abs +
                piece.points(capture).abs / 1.5 - piece.points.abs
        all << [get_input([piece, capture]), value]
      end
      piece.valid_moves.each do |the_move|
        value = piece.points(the_move).abs - piece.points.abs
        all << [get_input([piece, the_move]), value]
      end
      if piece.is_a?(Pawn) && piece.en_passant
        en_passants << "#{(piece.location[0] + 97).chr}x#{to_alg(piece.en_passant)}"
      end
    end
    # will reject castling later if not valid; insert in middle
    en_passants + all.sort { |a, b| b[1] <=> a[1] }
                     .map(&:first).insert(all.length / 2, 'O-O', 'O-O-O')
  end

  def choose_move(depth = 4)
    @@main_line_hash = {}
    @@prefix = white_to_move ? '' : '...'
    @@main_depth = depth
    @@positions_searched = 0
    white_to_move ? alpha_beta_max(self, depth)[0] : alpha_beta_min(self, depth)[0]
  end

  def alpha_beta_max(current, depth, alpha = -Float::INFINITY, beta = Float::INFINITY)
    # (MIN - depth) to prioritize move that gets checkmate sooner
    return end_score(current, MIN - depth) if current.over?
    return evaluate(current) if depth.zero?
    
    move_hash = {}
    current.find_valid_moves.each do |move|
      @@positions_searched += 1
      # necessary in order to make deep copy
      copy = Marshal.load(Marshal.dump(current))
      next unless copy.move(move)

      score = alpha_beta_min(copy, depth - 1, alpha, beta)[1]
      return [nil, beta] if score >= beta

      next unless score > alpha

      alpha = score
      if depth == 1
        line = copy.move_list.join.gsub(/\. {1,2}/, '.').split.last(@@main_depth)
        show_current_line(line)
        @@main_line_hash[score] = line
      elsif copy.over?
        line = copy.move_list.join.gsub(/\. {1,2}/, '.').split.last(@@main_depth - depth + 1)
        show_current_line(line)
        @@main_line_hash[score] = line
      end
      show_main_line(@@main_line_hash[score]) if depth == @@main_depth
      # add to hash only if candidate to avoid assigning alpha score to pruned move
      move_hash[move] = score
    end
    [move_hash.key(alpha), alpha]
  end

  def alpha_beta_min(current, depth, alpha = -Float::INFINITY, beta = Float::INFINITY)
    return end_score(current, MAX + depth) if current.over?
    return evaluate(current) if depth.zero?
    
    move_hash = {}
    current.find_valid_moves.each do |move|
      @@positions_searched += 1
      # necessary in order to make deep copy
      copy = Marshal.load(Marshal.dump(current))
      next unless copy.move(move)
      
      score = alpha_beta_max(copy, depth - 1, alpha, beta)[1]
      return [nil, alpha] if score <= alpha

      next unless score < beta

      beta = score
      if depth == 1
        line = copy.move_list.join.gsub(/\. {1,2}/, '.').split.last(@@main_depth)
        show_current_line(line)
        @@main_line_hash[score] = line
      elsif copy.over?
        line = copy.move_list.join.gsub(/\. {1,2}/, '.').split.last(@@main_depth - depth + 1)
        show_current_line(line)
        @@main_line_hash[score] = line
      end
      show_main_line(@@main_line_hash[score]) if depth == @@main_depth
      move_hash[move] = score
    end
    [move_hash.key(beta), beta]
  end

  def end_score(current, bound)
    current.in_check? ? [nil, bound] : [nil, 0]
  end

  def evaluate(current)
    score = 0
    current.each_piece do |piece|
      score += piece.points
    end
    # evaluating leaf position so no associated move
    [nil, score]
  end

  def endgame?
    material = 0
    queens = 0
    each_piece do |piece|
      next if piece.is_a?(King)

      material += piece.points.abs
      queens += 1 if piece.is_a?(Queen)
      return false if material > 4500 || queens > 1
    end
    true
  end

  def show_current_line(line)
    clear_line
    puts "Analyzing:  #{@@prefix}#{line.join(' ').gsub('.', '. ')}"
    move_up(1)
  end

  def show_main_line(line)
    puts
    clear_line
    puts "Main line:  #{@@prefix}#{line.join(' ').gsub('.', '. ')}".green
    move_up(2)
  end

  def benchmark
    puts 'Benchmarking..........'
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(2)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Depth of 2: #{elapsed} seconds, #{@@positions_searched} positions."

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(3)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Depth of 3: #{elapsed} seconds, #{@@positions_searched} positions."

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(4)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Depth of 4: #{elapsed} seconds, #{@@positions_searched} positions."
  end

  def get_input(info)
    piece = info[0]
    target = info[1]
    input = if piece.is_a?(Pawn)
              ''
            elsif piece.is_a?(Knight)
              'N'
            elsif piece.is_a?(Bishop)
              'B'
            elsif piece.is_a?(Rook)
              'R'
            elsif piece.is_a?(Queen)
              'Q'
            elsif piece.is_a?(King)
              'K'
            end
    action = squares[target[0]][target[1]].nil? ? 'move' : 'capture'
    if piece.is_a?(Pawn)
      if action == 'capture'
        input << (piece.location[0] + 97).chr
        input << 'x'
      end
      input << to_alg(target)
      input << '=Q' if [0, 7].include?(target[1])
    else
      candidates = find_candidates(piece.class, target, action)
      candidates = filter_by_legality(candidates, target)
      # don't need to check if length is 0 because already known that move is legal
      if candidates.length > 1
        finalists = []
        candidates.each { |c| finalists << c if c.location[0] == piece.location[0] }
        if finalists.length == 1
          input << (piece.location[0] + 97).chr
        else
          input << (piece.location[1] + 1).to_s
        end
      end
      input << 'x' if action == 'capture'
      input << to_alg(target)
    end
    input
  end
end
