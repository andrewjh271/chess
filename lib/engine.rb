# methods for Board class to allow engine logic
module Engine

  MIN = -99999
  MAX = 99999
  # @positions_searched = 0

  def find_valid_moves
    all = []
    en_passants = []
    each_piece do |piece|
      next unless piece.white? == white_to_move
      
      piece.valid_captures.each do |capture|
        value = squares[capture[0]][capture[1]].points.abs +
        piece.points(capture).abs - piece.points.abs 
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
    # will reject castling laster if not valid
    # insert toward end to avoid deep copy if pruned
    all.sort! { |a, b| b[1] <=> a[1] }.map!(&:first).insert(all.length / 1.5, 'O-O', 'O-O-O')
    en_passants + all
  end

  def choose_move(depth = 5)
    move = white_to_move ? alpha_beta_max(self, depth)[0] : alpha_beta_min(self, depth)[0]
    # puts @positions_searched
    move
  end

  def alpha_beta_max(current, depth, alpha = -Float::INFINITY, beta = Float::INFINITY)
    # MIN - depth to prioritize move that gets checkmate sooner
    return end_score(current, MIN - depth) if current.over?
    return evaluate(current) if depth.zero?
    
    move_hash = {}
    current.find_valid_moves.each do |move|
      @positions_searched += 1
      # necessary in order to make deep copy
      copy = Marshal.load(Marshal.dump(current))
      next unless copy.move(move)

      score = alpha_beta_min(copy, depth - 1, alpha, beta)[1]
      if score >= beta
        return [nil, beta]
      end
      if score > alpha
        alpha = score
        # add move/score pair to hash only if it is a candidate
        move_hash[move] = score
      end
    end

    move_pair = move_hash.find { |_k, v| v == alpha }
    move_pair || [nil, alpha]
  end

  def alpha_beta_min(current, depth, alpha = -Float::INFINITY, beta = Float::INFINITY)
    return end_score(current, MAX + depth) if current.over?
    return evaluate(current) if depth.zero?
    
    move_hash = {}
    current.find_valid_moves.each do |move|
      @positions_searched += 1
      # necessary in order to make deep copy
      copy = Marshal.load(Marshal.dump(current))
      next unless copy.move(move)

      score = alpha_beta_max(copy, depth - 1, alpha, beta)[1]
      if score <= alpha
        return [nil, alpha]
      end
      if score < beta
        beta = score
        move_hash[move] = score
      end
    end

    move_pair = move_hash.find { |_k, v| v == beta }
    move_pair || [nil, beta]
  end

  def end_score(current, bound)
    current.in_check? ? [nil, bound] : [nil, 0]
  end

  def evaluate(current)
    score = 0
    current.each_piece do |piece|
      score += piece.points
    end
    # evaluating leaf position — no associated move
    [nil, score]
  end

  def benchmark
    puts 'With pruning...'
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(2)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Depth of 2: #{elapsed} seconds"

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(3)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Depth of 3: #{elapsed} seconds"

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(4)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Depth of 4: #{elapsed} seconds"
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
      # don't need to check if length is 0 because move is legal
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