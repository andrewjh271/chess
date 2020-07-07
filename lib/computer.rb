require_relative 'board'
require 'pry'

class Computer
  attr_reader :color, :board

  def initialize(color)
    @color = color
    @board = board
  end

  def to_s
    color
  end

  def white?
    color == 'White'
  end

  def set_board(board)
    @board = board
  end

  def move
    # move_info = board.find_valid_move
    # input = get_input(move_info)
    # puts "Computer move: #{input}"
    # sleep(1)
    # board.move(input)

    moves = board.find_valid_moves
    board.move(moves.first)
  end

  # def get_input(info)
  #   piece = info[0]
  #   target = info[1]

  #   input = if piece.is_a?(Pawn)
  #             ''
  #           elsif piece.is_a?(Knight)
  #             'N'
  #           elsif piece.is_a?(Bishop)
  #             'B'
  #           elsif piece.is_a?(Rook)
  #             'R'
  #           elsif piece.is_a?(Queen)
  #             'Q'
  #           elsif piece.is_a?(King)
  #             'K'
  #           end
  #   action = board.squares[target[0]][target[1]].nil? ? 'move' : 'capture'

  #   if piece.is_a?(Pawn)
  #     if action == 'capture'
  #       input << (piece.location[0] + 97).chr
  #       input << 'x'
  #     end
  #     input << to_alg(target)
  #     if [0, 7].include?(target[1])
  #       piece = white? WhiteQueen.new(board, piece.location)
  #       input << '=Q'
  #     end
  #   else
  #     candidates = board.find_candidates(piece.class, target, action)
  #     candidates = board.filter_by_legality(candidates, target)
  #     # don't need to check if length is 0 because move is legal
  #     if candidates.length > 1
  #       finalists = []
  #       candidates.each { |c| finalists << c if c.location[0] == piece.location[0] }
  #       if finalists.length == 1
  #         input << (piece.location[0] + 97).chr
  #       else
  #         input << (piece.location[1] + 1).to_s
  #       end
  #     end
  #     input << 'x' if action == 'capture'
  #     input << to_alg(target)
  #   end
  #   input    
  # end



  # def to_alg(coordinates)
  #   (coordinates[0] + 97).chr + (coordinates[1] + 1).to_s
  # end
end