# methods for Board class to allow engine logic
module Engine

  MIN = -9999
  MAX = 9999
  @@positions_searched = 0

  def find_valid_moves
    # Board#move will reject castling laster if not valid
    all = %w[O-O O-O-O]
    each_piece do |piece|
      next unless piece.white? == white_to_move

      piece.valid_captures.each { |capture| all << get_input([piece, capture]) }
      piece.valid_moves.each { |a_move| all << get_input([piece, a_move]) }
      if piece.is_a?(Pawn) && piece.en_passant
        all << "#{(piece.location[0] + 97).chr}x#{to_alg(piece.en_passant)}"
      end
    end
    all
  end

  def choose_move(depth = 3)

    move = white_to_move ? alpha_beta_max(self, depth)[0] : alpha_beta_min(self, depth)[0]
    puts @@positions_searched
    move

    # return end_score(current) if current.over?

    # move_hash = {}
    # # set best to worst possible score
    # best = current.white_to_move ? MIN : MAX
    # current.find_valid_moves.each do |move|
    #   # necessary in order to make deep copy
    #   copy = Marshal.load(Marshal.dump(current))
    #   next unless copy.move(move)

    #   score = pry.zero? ? copy.find_score : choose_move(copy, pry - 1)[1]
    #   # if trying out moves for black (just moved, now white to move)
    #   if copy.white_to_move
    #     best = score if score < best
    #   else
    #     best = score if score > best
    #   end
    #   move_hash[move] = score
    # end
    # # game = collection.find { |k, _v| k.match?(/^#{input}/) }

    # # candidates = move_hash.select { |_k, v| v == best }
    # # candidates.sample
    # # binding.pry
    # move_pair = move_hash.find { |_k, v| v == best }
  end

  def alpha_beta_max(current, depth, alpha = -Float::INFINITY, beta = Float::INFINITY)
    return evaluate(current, MIN) if current.over?
    return evaluate(current) if depth.zero?
    
    move_hash = {}
    current.find_valid_moves.each do |move|
      @@positions_searched += 1
      # necessary in order to make deep copy
      copy = Marshal.load(Marshal.dump(current))
      
      next unless copy.move(move)

      # binding.pry
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
    # game = collection.find { |k, _v| k.match?(/^#{input}/) }

    # candidates = move_hash.select { |_k, v| v == best }
    # candidates.sample
    # binding.pry
    move_pair = move_hash.find { |_k, v| v == alpha }
    # binding.pry
    # puts @@positions_searched
    move_pair || [nil, alpha]
  end

  def alpha_beta_min(current, depth, alpha = -Float::INFINITY, beta = Float::INFINITY)
    return end_score(current, MAX) if current.over?
    return evaluate(current) if depth.zero?
    
    move_hash = {}
    current.find_valid_moves.each do |move|
      @@positions_searched += 1
      # necessary in order to make deep copy
      copy = Marshal.load(Marshal.dump(current))
    
      next unless copy.move(move)
      # binding.pry
      score = alpha_beta_max(copy, depth - 1, alpha, beta)[1]
      # binding.pry
      # if trying out moves for black (just moved, now white to move)
      if score <= alpha
        return [nil, alpha]
      end
      if score < beta
        beta = score
        move_hash[move] = score
      end
    end
    # if (move_hash.find { |_k, v| v == beta }).nil?
    #   binding.pry
    # end
    move_pair = move_hash.find { |_k, v| v == beta }
    # binding.pry
    move_pair || [nil, beta]
  end

  def end_score(current, bound)
    # if current.in_check?
    #   # checkmate
    #   score = current.white_to_move ? MIN : MAX
    #   [nil, score]
    # else
    #   # draw
    #   [nil, 0]
    # end
    # binding.pry
    current.in_check? ? [nil, bound] : [nil, 0]
  end

  def evaluate(current, bound = nil)
    if bound
      # game is over
      return current.in_check? ? [nil, bound] : [nil, 0]
    end

    score = 0
    current.each_piece do |piece|
      score += piece.points
    end
    # evaluating leaf position — no associated move
    [nil, score]
  end



  # def find_valid_moves2
  #   # Board#move will reject castling laster if not valid
  #   all = %w[O-O O-O-O]
  #   each_piece do |piece|
  #     next unless piece.white? == white_to_move

  #     piece.valid_captures.each { |capture| all << [piece, capture] }
  #     piece.valid_moves.each { |a_move| all << [piece, a_move] }
  #     if piece.is_a?(Pawn) && piece.en_passant
  #       all << "#{(piece.location[0] + 97).chr}x#{to_alg(piece.en_passant)}"
  #     end
  #   end
  #   all.shuffle
  # end

  # streamlined version of making full move
  # ignores update_repetitions and update_move_list
  # for castling and en_passant, makes a deep copy of board and actually moves
  # def engine_test(piece, target_square)
  #   squares[piece.location[0]][piece.location[1]] = nil
  #   old_locations << piece.location
  #   captured_pieces << squares[target_square[0]][target_square[1]]
  #   squares[target_square[0]][target_square[1]] = piece
  #   piece.location = [target_square[0], target_square[1]]
  #   add_en_passant(piece, target_square)
  #   moved_stack << piece.has_moved if piece.respond_to?(:has_moved)
  #   clear_en_passants
  #   set_moves_and_captures
  #   if in_check?
  #     @white_to_move = white_to_move ? false : true
  #     undo_engine_test(piece, target_square)
  #     return false
  #   end
  #   if piece.is_a?(Pawn) && [0,7].include?(piece.location[1])
  #     promoted_stack << piece
  #     piece = white_to_move ? WhiteQueen.new(self, piece.location) :
  #                             BlackQueen.new(self, piece.location)
  #   end
  #   @white_to_move = white_to_move ? false : true
  #   self
  # end

  # def undo_engine_test(piece, target_square)
  #   old_location = old_locations.pop
  #   captured_piece = captured_pieces.pop
  #   squares[old_location[0]][old_location[1]] = piece
  # end

  # def choose_move2(current = self, pry = 2)
  #   move_hash = {}
  #   best = current.white_to_move ? MIN : MAX
  #   current.find_valid_moves2.each do |move|
  #     if move.is_a?(Array)
  #       test_board = current.engine_test(move[0], move[1])
  #       next unless test_board
  #     else
  #       test_board = Marshal.load(Marshal.dump(current))
  #       next unless test_board.move(move)
  #     end
  #     score = pry.zero? ? test_board.find_score : choose_move(test_board, pry - 1)[1]
  #     if copy.white_to_move
  #       best = score if score < best
  #     else
  #       best = score if score > best
  #     end
  #     move_hash[move] = score
  #   end
  #   if move_hash.empty?
  #     if current.white_to_move
  #       score = current.in_check? ? MIN : 0
  #     else
  #       score = current.in_check? ? MAX : 0
  #     end
  #   end
  # end

  def benchmark
    puts 'With pruning...'
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(2)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Semi-slav move 13, depth of 2: #{elapsed} seconds"

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(3)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Semi-slav move 13, depth of 3: #{elapsed} seconds"

    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    choose_move(4)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts "Semi-slav move 13, depth of 4: #{elapsed} seconds"
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