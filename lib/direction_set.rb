# frozen_string_literal: true

# sets valid moves and captures using directions
module DirectionSet
  def find_valid_moves(directions)
    # non-captures
    valid_moves = []
    file = location[0]
    rank = location[1]
    directions.each do |direction|
      new_file = file + direction[0]
      new_rank = rank + direction[1]
      while new_file.between?(0, Board::MAX) &&
            new_rank.between?(0, Board::MAX) &&
            board.squares[new_file][new_rank].nil?
        valid_moves << [new_file, new_rank]
        new_file += direction[0]
        new_rank += direction[1]
      end
    end
    valid_moves
  end

  def find_valid_captures(directions)
    # does not safeguard against capturing opponents king b/c it cannot be in check
    valid_captures = []
    file = location[0]
    rank = location[1]
    directions.each do |direction|
      new_file = file + direction[0]
      new_rank = rank + direction[1]
      while new_file.between?(0, Board::MAX) &&
            new_rank.between?(0, Board::MAX) &&
            board.squares[new_file][new_rank].nil?
        new_file += direction[0]
        new_rank += direction[1]
      end
      next unless new_file.between?(0, Board::MAX) &&
                  new_rank.between?(0, Board::MAX) &&
                  board.squares[new_file][new_rank].white? != white?

      valid_captures << [new_file, new_rank]
    end
    valid_captures
  end
end
