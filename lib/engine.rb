# methods for Board class to allow engine logic
module Engine
  def find_valid_moves
    # Board#move will reject castling laster if not valid
    all = %w[O-O O-O-O]
    each_piece do |piece|
      next unless piece.white? == white_to_move

      piece.valid_moves.each { |a_move| all << get_input([piece, a_move]) }
      piece.valid_captures.each { |capture| all << get_input([piece, capture]) }
      if piece.is_a?(Pawn) && piece.en_passant
        all << "#{(piece.location[0] + 97).chr}x#{to_alg(piece.en_passant)}"
      end
    end
    # binding.pry
    all
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
      if [0, 7].include?(target[1])
        piece = piece.white? ? WhiteQueen.new(self, piece.location) : 
                               BlackQueen.new(self, piece.location)
        input << '=Q'
      end
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