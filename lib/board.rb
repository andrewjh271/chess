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

  attr_reader :squares, :white_to_move, :move_list, :move_number, :flip
  
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
    notation = input.clone
    # origionally /[KQRBN]|[a-h]x/
    target_piece = case notation.slice!(/[KQRBN]/)
            when 'K' then white_to_move ? WhiteKing : BlackKing
            when 'Q' then white_to_move ? WhiteQueen : BlackQueen
            when 'R' then white_to_move ? WhiteRook : BlackRook
            when 'B' then white_to_move ? WhiteBishop : BlackBishop
            when 'N' then white_to_move ? WhiteKnight : BlackKnight
            # when /[a-h]x/ then white_to_move ? WhitePawn : BlackPawn
            else white_to_move ? WhitePawn : BlackPawn
            end
    target_square = to_coords(notation.slice!(/[a-h][1-8]/))
    action = notation.slice!('x') ? 'capture' : 'move'
    candidates = []
    each_piece do |piece|
      next unless piece.is_a? target_piece

      candidates << piece if action == 'capture' && piece.valid_captures.include?(target_square)
      candidates << piece if action == 'move' && piece.valid_moves.include?(target_square)
    end
    if candidates.length == 1
      piece = candidates.first
    else
      piece = disambiguation(candidates, notation.slice!(0))
    end
    if piece
      enter_valid_move(piece, target_square, input)
    else
      puts "Not a valid move"
    end
  end

  private

  def enter_valid_move(piece, target_square, input)
    squares[piece.location[0]][piece.location[1]] = nil
    squares[target_square[0]][target_square[1]] = piece
    piece.location = [target_square[0], target_square[1]]
    piece.has_moved = true if piece.respond_to?(:has_moved)
    if white_to_move
      @move_list << +"#{move_number}. #{' ' if move_number < 10}#{input}"
      @white_to_move = false
    else
      justify = 10 - move_list.last.length
      @move_list.last << "#{' ' * justify}#{input}"
      @white_to_move = true
      @move_number += 1
    end
    display
    set_moves_and_captures
  end

  def disambiguation(candidates, selection)
    if selection.match(/[a-h]/)
      piece = candidates.find { |c| c.location[0] == selection.ord - 97 }
    elsif selection.match(/[1-8]/)
      piece = candidates.find { |c| c.location[1] == selection.to_i - 1 }
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
    print "| #{move_list[line] + 25}" if move_number > line + 25
    print "| #{move_list[line] + 50}" if move_number > line + 50
    print "| #{move_list[line] + 75}" if move_number > line + 75
    print "| #{move_list[line] + 100}" if move_number > line + 100
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

  def to_coords(notation)
    [notation[0].ord - 97, notation[1].to_i - 1]
  end

  def to_alg(coordinates)
    (coordinates[0] + 97).chr + (coordinates[1] + 1).to_s
  end

end
