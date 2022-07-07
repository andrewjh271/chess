# frozen_string_literal: true

require_relative 'escape_sequences'
require_relative 'color'
require_relative 'knight'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
require_relative 'engine'

# Board class handles all board logic
class Board
  include EscapeSequences
  include Engine

  attr_reader :squares, :white_to_move, :move_list, :move_number, :flip,
              :error_message, :remainder, :old_locations, :captured_pieces,
              :repetition_hash, :fifty_move_count

  attr_accessor :score

  MAX = 7
  ERRORS = {
    invalid: 'Invalid input',
    promotion: 'Invalid move (promotion input not valid)',
    check: 'Invalid move (cannot ignore or move into check)',
    extra_chars: 'Invalid move (extra characters)',
    no_file: 'Invalid move (file must be specified for pawn capture)',
    no_pawn_move: 'Invalid move (no pawn found to make requested move)',
    no_pawn_capture: 'Invalid move (no pawn found to make requested capture)',
    no_move: 'Invalid move (no piece found to make requested move)',
    no_capture: 'Invalid capture (no piece found to make requested capture)',
    disambiguation: 'Invalid move (disambiguation required)',
    kingside: 'Invalid move (kingside castling not possible)',
    queenside: 'Invalid move (queenside castling not possible)'
  }.freeze

  def initialize
    @squares = []
    @move_list = []
    @move_number = 0
    @white_to_move = true
    @flip = false
    @old_locations = []
    @captured_pieces = []
    @moved_stack = []
    @fifty_move_count = 0
    @repetition_hash = Hash.new(0)
    8.times { |i| @squares[i] = [] }
    fill_board
    add_position
    set_moves_and_captures
  end

  def display(num = 28)
    move_up(num)
    8.times do |i|
      m = flip ? i : 7 - i
      print_line(i, 0)
      print "#{m + 1} "
      print_line(i, 1, m)
      print_line(i, 2)
    end
    8.times do |i|
      m = flip ? 7 - i : i
      print "     #{(m + 97).chr} "
    end
    puts
    puts_clear
    puts
  end

  def flip_board(show_display = true)
    @flip = flip ? false : true
    display if show_display
  end

  def over?
    @score =
      if checkmate?
        white_to_move ? '0-1 Black Wins' : '1-0 White Wins'
      elsif stalemate?
        '1/2 - 1/2 Stalemate'
      elsif no_mating_material?
        '1/2 - 1/2 Insufficient Mating Material'
      elsif fifty_moves?
        '1/2 - 1/2 Fifty Move Rule'
      elsif threefold_repetition?
        '1/2 - 1/2 Draw by Threefold Repetition'
      end
    return score ? true : false
  end

  def move(input)
    input = input.dup
    return false unless validate_input(input)

    if input.slice!('O-O-O')
      castle_queenside(input)
    elsif input.slice!('O-O')
      castle_kingside(input)
    else
      notation = input.clone
      # removes parts of notation as they are used, and checks to make sure it's empty at end
      target_piece = find_target_piece(notation.slice!(/^[KQRBN]/))
      target_square = to_coords(notation.slice!(/[a-h][1-8]/))
      action = notation.slice!('x') ? 'capture' : 'move'
      if [WhitePawn, BlackPawn].include?(target_piece)
        piece = find_pawn(target_piece, target_square, action, input, notation)
        # en_passant returns true instead of piece location
        return piece if [true, false].include? piece

        piece = promote(piece, notation.slice!(0, 2)) if [0, 7].include?(target_square[1])
      else
        piece = find_piece(target_piece, target_square, action, notation)
      end
      return false unless piece

      test_move(piece, target_square)
      unless validate_move && check_remainder(input, notation)
        undo_test_move(piece, target_square)
        return false
      end
      undo_test_move(piece, target_square)
      enter_valid_move(piece, target_square, input)
    end
  end

  def validate_move
    # can't move into check (or ignore being in check)
    unless safe_king?
      @error_message = ERRORS[:check]
      return false
    end
    true
  end

  def check_remainder(input, notation)
    # validates remaining user input
    set_remainder
    if remainder.include?(notation)
      # adds + or # for check or checkmate if not already in input
      input << remainder.first unless notation == remainder.first
      true
    else
      @error_message = ERRORS[:extra_chars]
      false
    end
  end

  def in_check?
    target = white_to_move ? WhiteKing : BlackKing
    each_piece do |piece|
      next if piece.white? == white_to_move

      piece.valid_captures.each { |c| return true if squares[c[0]][c[1]].is_a? target }
    end
    false
  end

  def each_piece
    squares.each do |rank|
      rank.each do |square|
        square ? (yield square) : next
      end
    end
  end

  private

  def validate_input(input)
    @error_message = ERRORS[:invalid]
    return false unless input.match?(/[a-h][1-8]|O-O|O-O-O/)

    input.each_char { |char| return false unless char.match?(/[a-h]|[1-8]|[KQRBNOx\-=\+#]/) }
  end

  def find_target_piece(string)
    case string
    when 'K' then white_to_move ? WhiteKing : BlackKing
    when 'Q' then white_to_move ? WhiteQueen : BlackQueen
    when 'R' then white_to_move ? WhiteRook : BlackRook
    when 'B' then white_to_move ? WhiteBishop : BlackBishop
    when 'N' then white_to_move ? WhiteKnight : BlackKnight
    else white_to_move ? WhitePawn : BlackPawn
    end
  end

  def find_pawn(target_piece, target_square, action, input, notation)
    if action == 'capture'
      file = find_pawn_file(notation.slice!(0))
      return false unless file
    end
    each_piece do |piece|
      next unless piece.is_a? target_piece

      return piece if action == 'move' && piece.valid_moves.include?(target_square)

      if action == 'capture' && piece.location[0] == file
        return piece if piece.valid_captures.include?(target_square)
        return en_passant(piece, input, notation) if piece.en_passant == target_square
      end
    end
    @error_message = case action
                     when 'move' then ERRORS[:no_pawn_move]
                     when 'capture' then ERRORS[:no_pawn_capture]
                     end
    false
  end

  def find_pawn_file(char)
    if char&.match?(/[a-h]/)
      char.ord - 97
    else
      @error_message = ERRORS[:no_file]
      false
    end
  end

  def find_piece(target_piece, target_square, action, notation)
    candidates = find_candidates(target_piece, target_square, action)
    if candidates.length.zero?
      @error_message = case action
                       when 'move' then ERRORS[:no_move]
                       when 'capture' then ERRORS[:no_capture]
                       end
      false
    elsif candidates.length == 1
      candidates.first
    else
      # finds which target piece is intended
      disambiguation(candidates, target_square, notation)
    end
  end

  def find_candidates(target_piece, target_square, action)
    # deals with case where multiple target pieces could move to target square
    candidates = []
    each_piece do |piece|
      next unless piece.is_a? target_piece

      if action == 'move' && piece.valid_moves.include?(target_square)
        candidates << piece
      elsif action == 'capture' && piece.valid_captures.include?(target_square)
        candidates << piece
      end
    end
    candidates
  end

  def disambiguation(candidates, target_square, notation)
    # error message only used if #disambiguation returns false
    @error_message = ERRORS[:disambiguation]
    # first check if any of the moves is illegal
    finalists = filter_by_legality(candidates, target_square)
    return finalists.first if finalists.length == 1

    finalists = filter_by_location(candidates, notation.slice!(0))
    finalists.first if finalists.length == 1
  end

  def filter_by_legality(candidates, target_square)
    candidates.reject do |piece|
      test_move(piece, target_square)
      illegal = in_check?
      undo_test_move(piece, target_square)
      illegal
    end
  end

  def filter_by_location(candidates, selection)
    finalists = []
    # only accepts the rank or file that narrows down candidates
    if selection&.match?(/[a-h]/)
      candidates.each { |c| finalists << c if c.location[0] == selection.ord - 97 }
    elsif selection&.match?(/[1-8]/)
      candidates.each { |c| finalists << c if c.location[1] == selection.to_i - 1 }
    end
    finalists
  end

  def test_move(piece, target_square = nil)
    squares[piece.location[0]][piece.location[1]] = nil
    old_locations << piece.location
    if target_square
      captured_pieces << squares[target_square[0]][target_square[1]]
      squares[target_square[0]][target_square[1]] = piece
      piece.location = target_square
    else
      # must be en_passant
      squares[piece.en_passant[0]][piece.en_passant[1]] = piece
      captured_pieces << squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]]
      squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]] = nil
      piece.location = piece.en_passant
    end
    set_moves_and_captures
  end

  def undo_test_move(piece, target_square = nil)
    old_location = old_locations.pop
    captured_piece = captured_pieces.pop
    squares[old_location[0]][old_location[1]] = piece
    if target_square
      squares[target_square[0]][target_square[1]] = captured_piece
    else
      # must be en_passant
      squares[piece.en_passant[0]][piece.en_passant[1]] = nil
      squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]] = captured_piece
    end
    piece.location = old_location
    set_moves_and_captures
  end

  def safe_king?
    !in_check?
  end

  def checkmate?
    return false unless in_check?

    no_moves?
  end

  def stalemate?
    return false unless safe_king?

    no_moves?
  end

  def fifty_moves?
    fifty_move_count >= 50
  end

  def threefold_repetition?
    repetition_hash.any? { |_k, v| v > 2 }
  end

  def no_mating_material?
    pieces_left = []
    each_piece do |piece|
      return false if piece.is_a?(Pawn) || piece.is_a?(Rook) || piece.is_a?(Queen)
      next if piece.is_a?(King)

      pieces_left << piece
    end
    return true if pieces_left.length < 2 ||
                   pieces_left == 2 && pieces_left[0].is_a?(Bishop) &&
                   pieces_left[1].is_a?(Bishop) &&
                   pieces_left[0].dark_squared? == pieces_left[1].dark_squared?
                   
    false
  end

  def update_repetitions(irreversible, altered_state)
    @fifty_move_count = irreversible ? 0.5 : (fifty_move_count + 0.5)
    clear_positions if altered_state
    add_position
  end

  def add_position
    # yaml does not save default value for Hash
    if repetition_hash[snapshot]
      repetition_hash[snapshot] += 1
    else
      repetition_hash[snapshot] = 0
    end
  end

  def clear_positions
    @repetition_hash = Hash.new(0)
  end

  def no_moves?
    each_piece do |piece|
      next unless piece.white? == white_to_move

      piece.valid_moves.each do |a_move|
        test_move(piece, a_move)
        if safe_king?
          undo_test_move(piece, a_move)
          return false
        end
        undo_test_move(piece, a_move)
      end
      piece.valid_captures.each do |capture|
        test_move(piece, capture)
        if safe_king?
          undo_test_move(piece, capture)
          return false
        end
        undo_test_move(piece, capture)
      end
      if piece.is_a?(Pawn) && piece.en_passant
        test_move(piece)
        if safe_king?
          undo_test_move(piece)
          return false
        end
      end
      # castling can't be only valid move
    end
    true
  end

  def set_remainder
    # checks whether side not to move will be put in check or checkmate
    @white_to_move = white_to_move ? false : true
    @remainder = if checkmate?
                   ['#', '']
                 elsif in_check?
                   ['+', '']
                 else
                   ['']
                 end
    @white_to_move = white_to_move ? false : true
  end

  def enter_valid_move(piece, target_square, input)
    squares[piece.location[0]][piece.location[1]] = nil
    squares[target_square[0]][target_square[1]] = piece
    add_en_passant(piece, target_square)
    piece.location = target_square
    update_move_list(input)
    piece.has_moved if piece.respond_to?(:has_moved)
    irreversible = piece.is_a?(Pawn) || input.include?('x')
    finalize_move(irreversible, irreversible)
  end

  def finalize_move(irreversible = false, altered_state = true)
    # parameters for 50 move rule and threefold repetition; #castle doesn't provide argument
    clear_en_passants
    @white_to_move = white_to_move ? false : true
    update_repetitions(irreversible, altered_state)
    set_moves_and_captures
    true
  end

  def update_move_list(input)
    if white_to_move
      @move_number += 1
      @move_list << +"#{move_number}. #{' ' if move_number < 10}#{input}"
    else
      justify_left = 12 - move_list.last.length
      justify_right = 8 - input.length
      @move_list.last << "#{' ' * justify_left}#{input}#{' ' * justify_right}"
    end
  end

  def print_line(i, k, rank = nil)
    print '  ' unless rank
    8.times do |j|
      m = flip ? 7 - j : j
      piece = squares[m][rank] if rank
      if (i + j).even?
        print "   #{piece || ' '}".bg_cyan + "   ".bg_cyan
      else
        print "   #{piece || ' '}".bg_blue + "   ".bg_blue
      end
    end
    display_moves(i * 3 + k)
    puts
  end

  def display_moves(line)
    print " #{move_list[line]}" if move_number > line
    print "| #{move_list[line + 24]}" if move_number > line + 24
    print "| #{move_list[line + 48]}" if move_number > line + 48
    print "| #{move_list[line + 72]}" if move_number > line + 72
    print "| #{move_list[line + 96]}" if move_number > line + 96
    print "| #{move_list[line + 120]}" if move_number > line + 120
    print "| #{move_list[line + 144]}" if move_number > line + 144
  end

  def fill_board
    squares[0][0] = WhiteRook.new(self, [0, 0])
    squares[7][0] = WhiteRook.new(self, [7, 0])
    squares[1][0] = WhiteKnight.new(self, [1, 0])
    squares[6][0] = WhiteKnight.new(self, [6, 0])
    squares[2][0] = WhiteBishop.new(self, [2, 0])
    squares[5][0] = WhiteBishop.new(self, [5, 0])
    squares[3][0] = WhiteQueen.new(self, [3, 0])
    squares[4][0] = WhiteKing.new(self, [4, 0])
    8.times { |i| squares[i][1] = WhitePawn.new(self, [i, 1]) }
    squares[0][7] = BlackRook.new(self, [0, 7])
    squares[7][7] = BlackRook.new(self, [7, 7])
    squares[1][7] = BlackKnight.new(self, [1, 7])
    squares[6][7] = BlackKnight.new(self, [6, 7])
    squares[2][7] = BlackBishop.new(self, [2, 7])
    squares[5][7] = BlackBishop.new(self, [5, 7])
    squares[3][7] = BlackQueen.new(self, [3, 7])
    squares[4][7] = BlackKing.new(self, [4, 7])
    8.times { |i| squares[i][6] = BlackPawn.new(self, [i, 6]) }
  end

  def set_moves_and_captures
    each_piece do |piece|
      piece.set_valid_moves
      piece.set_valid_captures
    end
  end

  def castle_kingside(notation)
    rank = white_to_move ? 0 : 7
    targets = [[4, rank], [7, rank]]
    empty_squares = [[5, rank], [6, rank]]
    return false unless validate_castle(targets, empty_squares, 'kingside')

    castle(targets[0], targets[1], empty_squares[1], empty_squares[0], +'O-O', notation)
  end

  def castle_queenside(notation)
    rank = white_to_move ? 0 : 7
    targets = [[4, rank], [0, rank]]
    empty_squares = [[3, rank], [2, rank], [1, rank]]
    return false unless validate_castle(targets, empty_squares)

    castle(targets[0], targets[1], empty_squares[1], empty_squares[0], +'O-O-O', notation)
  end

  def validate_castle(targets, empty_squares, kingside = false)
    # error message only used if #move returns false
    @error_message = case kingside
                     when 'kingside' then ERRORS[:kingside]
                     else ERRORS[:queenside]
                     end
    return false if in_check?

    targets.each do |t|
      return false unless (squares[t[0]][t[1]].is_a?(King) || squares[t[0]][t[1]].is_a?(Rook)) &&
                          !squares[t[0]][t[1]].has_moved?
    end
    # ensures squares between are empty
    empty_squares.each { |e| return false unless squares[e[0]][e[1]].nil? }

    each_piece do |piece|
      next if piece.white? == white_to_move

      # ensures king won't move into check along the way
      return false unless (piece.valid_moves & empty_squares.first(2)).empty?
    end
    true
  end

  def test_castle(king, rook, new_king, new_rook)
    # arguments will be locations of king and rook
    squares[new_king[0]][new_king[1]] = squares[king[0]][king[1]]
    squares[king[0]][king[1]] = nil
    squares[new_rook[0]][new_rook[1]] = squares[rook[0]][rook[1]]
    squares[rook[0]][rook[1]] = nil

    squares[new_king[0]][new_king[1]].location = new_king
    squares[new_rook[0]][new_rook[1]].location = new_rook
    set_moves_and_captures
  end

  def undo_test_castle(king, rook, new_king, new_rook)
    squares[king[0]][king[1]] = squares[new_king[0]][new_king[1]]
    squares[new_king[0]][new_king[1]] = nil
    squares[rook[0]][rook[1]] = squares[new_rook[0]][new_rook[1]]
    squares[new_rook[0]][new_rook[1]] = nil

    squares[king[0]][king[1]].location = king
    squares[rook[0]][rook[1]].location = rook
    set_moves_and_captures
  end

  def castle(king, rook, new_king, new_rook, input, notation)
    test_castle(king, rook, new_king, new_rook)
    unless check_remainder(input, notation)
      undo_test_castle(king, rook, new_king, new_rook)
      return false
    end
    # leaves assignments from #test_castle b/c nothing else to check
    update_move_list(input)
    squares[new_king[0]][new_king[1]].has_moved
    squares[new_rook[0]][new_rook[1]].has_moved
    finalize_move
  end

  def en_passant(piece, input, notation)
    @error_message = ERRORS[:no_pawn_capture]
    return false unless validate_en_passant(piece, input, notation)

    # adds + or # for check or checkmate if not already in input
    input << remainder.first unless notation == remainder.first
    squares[piece.location[0]][piece.location[1]] = nil
    squares[piece.en_passant[0]][piece.en_passant[1]] = piece
    squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]] = nil
    piece.location = piece.en_passant
    update_move_list(input)
    finalize_move
  end

  def validate_en_passant(piece, input, notation)
    test_move(piece)
    unless validate_move && check_remainder(input, notation)
      undo_test_move(piece)
      return false
    end
    undo_test_move(piece)
    true
  end

  def promote(piece, notation)
    @error_message = ERRORS[:promotion]
    return false unless piece && notation[0] == '='

    case notation[1]
    when 'Q' then white_to_move ? WhiteQueen.new(self, piece.location) :
                                  BlackQueen.new(self, piece.location)
    when 'R' then white_to_move ? WhiteRook.new(self, piece.location) :
                                  BlackRook.new(self, piece.location)
    when 'B' then white_to_move ? WhiteBishop.new(self, piece.location) :
                                  BlackBishop.new(self, piece.location)
    when 'N' then white_to_move ? WhiteKnight.new(self, piece.location) :
                                  BlackKnight.new(self, piece.location)
    else false
    end
  end

  def add_en_passant(piece, target_square)
    return unless piece.is_a?(Pawn) && (target_square[1] - piece.location[1]).abs == 2

    # check for adjacent enemy pawns
    target = white_to_move ? BlackPawn : WhitePawn
    file = target_square[0]
    rank = target_square[1]
    if file.positive?
      adj = squares[file - 1][rank]
      adj.add_en_passant(file) if adj&.is_a?(target)
    end
    if file < 7
      adj = squares[file + 1][rank]
      adj.add_en_passant(file) if adj&.is_a?(target)
    end
  end

  def clear_en_passants
    # only for side that just moved
    each_piece do |piece|
      next unless piece.is_a?(Pawn) && piece.white? == white_to_move

      piece.remove_en_passant
    end
  end

  def to_coords(notation)
    [notation[0].ord - 97, notation[1].to_i - 1]
  end

  def to_alg(coordinates)
    (coordinates[0] + 97).chr + (coordinates[1] + 1).to_s
  end

  def each_square
    squares.each do |rank|
      rank.each do |square|
        yield square
      end
    end
  end

  # unique identifier for each position
  def snapshot
    string = white_to_move ? '0'.dup : '1'.dup
    each_square do |square|
      string << if square
                  square.identifier
                else
                  'z'
                end
    end
    string
  end
end
