# frozen_string_literal: true

require_relative 'escape_sequences'
require_relative 'color'
require_relative 'knight'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'pawn'
require 'pry'

# ♟ ♞ ♝ ♜ ♛ ♚ ♙ ♘ ♗ ♖ ♕ ♔
class Board
  
  include EscapeSequences

  attr_reader :squares, :white_to_move, :move_list, :move_number, :flip,
              :remainder, :old_location, :captured_piece
  
  MAX = 7

  def initialize
    @squares = []
    @move_list = []
    @move_number = 1
    @white_to_move = true
    @flip = false
    8.times { |i| @squares[i] = [] }
    fill_board
    set_moves_and_captures
  end

  def display
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
    2.times { puts }
  end

  def flip_board
    @flip = flip ? false : true
    display
  end

  def each_piece
    squares.each do |rank|
      rank.each do |square|
        square ? (yield square) : next
      end
    end
  end

  def move(input)
    if input.slice!('0-0-0')
      castle_queenside(input)
    elsif input.slice!('0-0')
      castle_kingside(input)
    else
      notation = input.clone
      # removes parts of notation as they are used, and checks to make sure it's empty at end
      target_piece = find_target_piece(notation.slice!(/^[KQRBN]/))
      target_square = to_coords(notation.slice!(/[a-h][1-8]/))
      action = notation.slice!('x') ? 'capture' : 'move'
      # candidates deals with case where multiple target pieces could move to target square
      candidates = []
      each_piece do |piece|
        next unless piece.is_a? target_piece
        
        if action == 'move' && piece.valid_moves.include?(target_square)
          candidates << piece
        elsif action == 'capture' && piece.valid_captures.include?(target_square)
          # special treatment needed for Pawn because of chess algebraic notation
          if piece.is_a?(Pawn) && piece.location[0] == notation[0].ord - 97
            notation.slice!(0)
            candidates << piece
          elsif !piece.is_a?(Pawn)
            candidates << piece
          end
        elsif action == 'capture' && piece.respond_to?(:en_passant) && piece.en_passant == target_square
          return en_passant(piece, input, notation)
        end
      end
      if candidates.length == 0
        return false
      elsif candidates.length == 1
        piece = candidates.first
      else
        # finds which target piece is intended
        piece = disambiguation(candidates, notation.slice!(0))
      end
      if piece
        test_move(piece, target_square)
        unless safe_king?
          puts 'Invalid move: king in check'
          undo_test_move(piece, target_square)
          return false
        end
        # pawn promotion
        if piece.is_a?(Pawn) && !target_square[1].between?(1, 6)
          piece = promote(piece, notation.slice!(0, 2))
          unless piece
            puts "Invalid move: promotion input not valid"
            undo_test_move(piece, target_square)
            return false
          end
        end
        # validates remaining user input
        set_remainder
        if remainder.include?(notation)
          # adds + or # for check or checkmate if not already in input
          input << remainder.first unless notation == remainder.first
        else
          puts "Invalid move: extra characters"
          undo_test_move(piece, target_square)
          return false
        end
        undo_test_move(piece, target_square)
        enter_valid_move(piece, target_square, input)
        return true
      else
        puts "Not a valid move"
        return false
      end
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

  private

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

  def find_candidates(target_piece, target_square, action)
    candidates = []
      each_piece do |piece|
        next unless piece.is_a? target_piece
        
        if action == 'move' && piece.valid_moves.include?(target_square)
          candidates << piece
        elsif action == 'capture' && piece.valid_captures.include?(target_square)
          # special treatment needed for Pawn because of chess algebraic notation
          if piece.is_a?(Pawn) && piece.location[0] == notation[0].ord - 97
            notation.slice!(0)
            candidates << piece
          elsif !piece.is_a?(Pawn)
            candidates << piece
          end
        elsif action == 'capture' && piece.respond_to?(:en_passant) && piece.en_passant
          return en_passant(piece, input, notation)
        end
      end
  end

  def test_move(piece, target_square = nil)
    squares[piece.location[0]][piece.location[1]] = nil
    @old_location = piece.location
    if target_square
      @captured_piece = squares[target_square[0]][target_square[1]]
      squares[target_square[0]][target_square[1]] = piece
      piece.location = [target_square[0], target_square[1]]
    else
      # must be en_passant
      squares[piece.en_passant[0]][piece.en_passant[1]] = piece
      @captured_piece = squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]]
      squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]] = nil
      piece.location = [piece.en_passant[0], piece.en_passant[1]]
    end
    test_captures
  end

  def undo_test_move(piece, target_square = nil)
    squares[old_location[0]][old_location[1]] = piece
    if target_square
      squares[target_square[0]][target_square[1]] = captured_piece
    else
      # must be en_passant
      squares[piece.en_passant[0]][piece.en_passant[1]] = nil
      squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]] = captured_piece
    end
    piece.location = [old_location[0], old_location[1]]
    test_captures
  end

  def safe_king?
    !in_check?
  end

  def enter_valid_move(piece, target_square, input)
    squares[piece.location[0]][piece.location[1]] = nil
    squares[target_square[0]][target_square[1]] = piece
    add_en_passant(piece, target_square)
    piece.location = [target_square[0], target_square[1]]
    update_move_list(input)
    piece.has_moved = true if piece.respond_to?(:has_moved)
    clear_en_passants
    @white_to_move = white_to_move ? false : true
    set_moves_and_captures
    display
  end

  def set_remainder
    # checks whether side not to move will be put in check or checkmate
    @white_to_move = white_to_move ? false : true
    # binding.pry
    if in_check?
      @remainder = ['+', ''] 
    # elsif checkmate?
    #   @remainder = ['#', '']
    else
      @remainder = ['']
    end
    @white_to_move = white_to_move ? false : true
  end

  def add_en_passant(piece, target_square)
    if piece.is_a?(Pawn) && (target_square[1] - piece.location[1]).abs == 2
      # check for adjacent enemy pawns
      target = white_to_move ? BlackPawn : WhitePawn
      file = target_square[0]
      rank = target_square[1]
      if file > 0
        adj = squares[file - 1][rank]
        adj.add_en_passant(file) if adj && adj.is_a?(target)
      end
      if file < 7
        adj = squares[file + 1][rank]
        adj.add_en_passant(file) if adj && adj.is_a?(target)
      end
    end
  end

  def clear_en_passants
    # only for side that just moved
    each_piece do |piece|
      next unless piece.is_a?(Pawn) && piece.white? == white_to_move

      piece.remove_en_passant
    end
  end

  def update_move_list(input)
    if white_to_move
      @move_list << +"#{move_number}. #{' ' if move_number < 10}#{input}"
    else
      justify_left = 11 - move_list.last.length
      justify_right = 7 - input.length
      @move_list.last << "#{' ' * justify_left}#{input}#{' ' * justify_right}"
      @move_number += 1
    end
  end

  def disambiguation(candidates, selection)
    return false unless selection
    
    # only accepts the rank or file that narrows down candidates 
    finalists = []
    if selection.match(/[a-h]/)
      candidates.each { |c| finalists << c if c.location[0] == selection.ord - 97 }
    elsif selection.match(/[1-8]/)
      candidates.each { |c| finalists << c if c.location[1] == selection.to_i - 1 }
    end
    return finalists.first if finalists.length == 1
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
    print "| #{move_list[line + 25]}" if move_number > line + 25
    print "| #{move_list[line + 50]}" if move_number > line + 50
    print "| #{move_list[line + 75]}" if move_number > line + 75
    print "| #{move_list[line + 100]}" if move_number > line + 100
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

  def test_captures
    each_piece(&:set_valid_captures)
  end

  def castle_kingside(notation)
    rank = white_to_move ? 0 : 7
    targets = [[4, rank], [7, rank]]
    empty_squares = [[5, rank], [6, rank]]
    return false unless validate_castle(targets, empty_squares)
    
    castle(targets[0], targets[1], empty_squares[1], empty_squares[0], +'0-0', notation)
  end

  def castle_queenside(notation)
    rank = white_to_move ? 0 : 7
    targets = [[4, rank], [0, rank]]
    empty_squares = [[3, rank], [2, rank], [1, rank]]
    return false unless validate_castle(targets, empty_squares)

    castle(targets[0], targets[1], empty_squares[1], empty_squares[0], +'0-0-0', notation)
  end

  def validate_castle(targets, empty_squares)
    return false if in_check?
    targets.each { |t| return false if squares[t[0]][t[1]].has_moved }
    # ensures squares between are empty
    empty_squares.each { |e| return false unless squares[e[0]][e[1]].nil? }

    each_piece do |piece|
      next if piece.white? == white_to_move

      # ensures king won't move into check along the way
      # by making sure intersection of two arrays is empty
      return false unless (piece.valid_moves & empty_squares.first(2)).empty?
    end
    true
  end

  def test_castle(king, rook, new_king, new_rook)
    squares[new_king[0]][new_king[1]] = squares[king[0]][king[1]]
    squares[king[0]][king[1]] = nil
    squares[new_rook[0]][new_rook[1]] = squares[rook[0]][rook[1]]
    squares[rook[0]][rook[1]] = nil

    squares[new_king[0]][new_king[1]].location = [new_king[0], new_king[1]]
    squares[new_rook[0]][new_rook[1]].location = [new_rook[0], new_rook[1]]
    test_captures
  end

  def undo_test_castle(king, rook, new_king, new_rook)
    squares[king[0]][king[1]] = squares[new_king[0]][new_king[1]]
    squares[new_king[0]][new_king[1]] = nil
    squares[rook[0]][rook[1]] = squares[new_rook[0]][new_rook[1]]
    squares[new_rook[0]][new_rook[1]] = nil

    squares[king[0]][king[1]].location = [king[0], king[1]]
    squares[rook[0]][rook[1]].location = [rook[0], rook[1]]
    test_captures
  end

  def castle(king, rook, new_king, new_rook, input, notation)
    test_castle(king, rook, new_king, new_rook)
    set_remainder
    if remainder.include?(notation)
      # adds + or # for check or checkmate if not already in input
      input << remainder.first
    else
      puts "Invalid move: extra characters"
      undo_test_castle(king, rook, new_king, new_rook)
      return false
    end
    # leaves assignments from #test_castle b/c nothing else to check
    update_move_list(input)
    squares[new_king[0]][new_king[1]].has_moved = true
    squares[new_rook[0]][new_rook[1]].has_moved = true
    clear_en_passants
    @white_to_move = white_to_move ? false : true
    set_moves_and_captures
    display
    true
  end

  def en_passant(piece, input, notation)
    return false unless validate_en_passant(piece, input, notation)

    # adds + or # for check or checkmate if not already in input
    input << remainder.first unless notation == remainder.first
    squares[piece.location[0]][piece.location[1]] = nil
    squares[piece.en_passant[0]][piece.en_passant[1]] = piece
    squares[piece.en_passant_capture[0]][piece.en_passant_capture[1]] = nil
    piece.location = piece.en_passant
    update_move_list(input)
    clear_en_passants
    @white_to_move = white_to_move ? false : true
    set_moves_and_captures
    display
    true
  end

  def promote(piece, notation)
    return false unless notation[0] == '='

    sq = [piece.location[0], piece.location[1]]
    case notation[1]
    when 'Q' then white_to_move ? WhiteQueen.new(self, [sq[0], sq[1]]) :
                                  BlackQueen.new(self, [sq[0], sq[1]])
    when 'R' then white_to_move ? WhiteRook.new(self, [sq[0], sq[1]]) :
                                  BlackRook.new(self, [sq[0], sq[1]])
    when 'B' then white_to_move ? WhiteBishop.new(self, [sq[0], sq[1]]) :
                                  BlackBishop.new(self, [sq[0], sq[1]])
    when 'N' then white_to_move ? WhiteKnight.new(self, [sq[0], sq[1]]) :
                                  BlackKnight.new(self, [sq[0], sq[1]])
    else false
    end
  end

  def validate_en_passant(piece, input, notation)
    if piece.location[0] == notation[0].ord - 97
      notation.slice!(0)
    else
      puts 'Invalid move: pawn not found'
      return false
    end
    test_move(piece)
    unless safe_king?
      puts 'Invalid move: king in check'
      undo_test_move(piece)
      return false
    end
    # validates remaining user input
    set_remainder
    if remainder.include?(notation)
      undo_test_move(piece)
      true
    else
      puts "Invalid move: extra characters"
      undo_test_move(piece)
      false
    end
  end

  def to_coords(notation)
    [notation[0].ord - 97, notation[1].to_i - 1]
  end

  def to_alg(coordinates)
    (coordinates[0] + 97).chr + (coordinates[1] + 1).to_s
  end

end
