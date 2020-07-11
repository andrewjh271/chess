module Piece_Square_Tables
  WHITE_PAWN_TABLE = {
    # 1st and 8th rank values unncessary
    [0, 1] => 5,
    [1, 1] => 10,
    [2, 1] => 10,
    [3, 1] => -20,
    [4, 1] => -20,
    [5, 1] => 10,
    [6, 1] => 10,
    [7, 1] => 5,
    [0, 2] => 5,
    [1, 2] => -5,
    [2, 2] => -10,
    [3, 2] => 0,
    [4, 2] => 0,
    [5, 2] => -10,
    [6, 2] => -5,
    [7, 2] => 5,
    [0, 3] => 0,
    [1, 3] => 0,
    [2, 3] => 0,
    [3, 3] => 20,
    [4, 3] => 20,
    [5, 3] => 0,
    [6, 3] => 0,
    [7, 3] => 0,
    [0, 4] => 5,
    [1, 4] => 5,
    [2, 4] => 10,
    [3, 4] => 25,
    [4, 4] => 25,
    [5, 4] => 10,
    [6, 4] => 5,
    [7, 4] => 5,
    [0, 5] => 10,
    [1, 5] => 10,
    [2, 5] => 20,
    [3, 5] => 30,
    [4, 5] => 30,
    [5, 5] => 20,
    [6, 5] => 10,
    [7, 5] => 10,
    [0, 6] => 50,
    [1, 6] => 50,
    [2, 6] => 50,
    [3, 6] => 50,
    [4, 6] => 50,
    [5, 6] => 50,
    [6, 6] => 50,
    [7, 6] => 50
  }.freeze

  BLACK_PAWN_TABLE = {
    # not bothering with 1st and 8th rank values
    [0, 1] => -50,
    [1, 1] => -50,
    [2, 1] => -50,
    [3, 1] => -50,
    [4, 1] => -50,
    [5, 1] => -50,
    [6, 1] => -50,
    [7, 1] => -50,
    [0, 2] => -10,
    [1, 2] => -10,
    [2, 2] => -20,
    [3, 2] => -30,
    [4, 2] => -30,
    [5, 2] => -20,
    [6, 2] => -10,
    [7, 2] => -10,
    [0, 3] => -5,
    [1, 3] => -5,
    [2, 3] => -10,
    [3, 3] => -25,
    [4, 3] => -25,
    [5, 3] => -10,
    [6, 3] => -5,
    [7, 3] => -5,
    [0, 4] => 0,
    [1, 4] => 0,
    [2, 4] => 0,
    [3, 4] => -20,
    [4, 4] => -20,
    [5, 4] => 0,
    [6, 4] => 0,
    [7, 4] => 0,
    [0, 5] => -5,
    [1, 5] => 5,
    [2, 5] => 10,
    [3, 5] => 0,
    [4, 5] => 0,
    [5, 5] => 10,
    [6, 5] => 5,
    [7, 5] => -5,
    [0, 6] => -5,
    [1, 6] => -10,
    [2, 6] => -10,
    [3, 6] => 20,
    [4, 6] => 20,
    [5, 6] => -10,
    [6, 6] => -10,
    [7, 6] => -5
  }.freeze

  WHITE_BISHOP_TABLE = {
    [0, 0] => -20,
    [1, 0] => -10,
    [2, 0] => -10,
    [3, 0] => -10,
    [4, 0] => -10,
    [5, 0] => -10,
    [6, 0] => -10,
    [7, 0] => -20,
    [0, 1] => -10,
    [1, 1] => 5, 
    [2, 1] => 0,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => 5,
    [7, 1] => -10,
    [0, 2] => -10,
    [1, 2] => 10,
    [2, 2] => 10,
    [3, 2] => 10,
    [4, 2] => 10,
    [5, 2] => 10,
    [6, 2] => 10,
    [7, 2] => -10,
    [0, 3] => -10,
    [1, 3] => 0,
    [2, 3] => 10,
    [3, 3] => 10,
    [4, 3] => 10,
    [5, 3] => 10,
    [6, 3] => 0,
    [7, 3] => -10,
    [0, 4] => -10,
    [1, 4] => 5,
    [2, 4] => 5,
    [3, 4] => 10,
    [4, 4] => 10,
    [5, 4] => 5,
    [6, 4] => 5,
    [7, 4] => -10,
    [0, 5] => -10,
    [1, 5] => 0,
    [2, 5] => 5,
    [3, 5] => 10,
    [4, 5] => 10,
    [5, 5] => 5,
    [6, 5] => 0,
    [7, 5] => -10,
    [0, 6] => -10,
    [1, 6] => 0, 
    [2, 6] => 0,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => 0,
    [7, 6] => -10,
    [0, 7] => -20,
    [1, 7] => -10,
    [2, 7] => -10,
    [3, 7] => -10,
    [4, 7] => -10,
    [5, 7] => -10,
    [6, 7] => -10,
    [7, 7] => -20,
  }.freeze

  BLACK_BISHOP_TABLE = {
    [0, 0] => 20,
    [1, 0] => 10,
    [2, 0] => 10,
    [3, 0] => 10,
    [4, 0] => 10,
    [5, 0] => 10,
    [6, 0] => 10,
    [7, 0] => 20,
    [0, 1] => 10,
    [1, 1] => 0, 
    [2, 1] => 0,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => 0,
    [7, 1] => 10,
    [0, 2] => 10,
    [1, 2] => 0,
    [2, 2] => -5,
    [3, 2] => -10,
    [4, 2] => -10,
    [5, 2] => -5,
    [6, 2] => 0,
    [7, 2] => 10,
    [0, 3] => 10,
    [1, 3] => -5,
    [2, 3] => -5,
    [3, 3] => -10,
    [4, 3] => -10,
    [5, 3] => -5,
    [6, 3] => -5,
    [7, 3] => 10,
    [0, 4] => 10,
    [1, 4] => 0,
    [2, 4] => -10,
    [3, 4] => -10,
    [4, 4] => -10,
    [5, 4] => -10,
    [6, 4] => 0,
    [7, 4] => 10,
    [0, 5] => 10,
    [1, 5] => -10,
    [2, 5] => -10,
    [3, 5] => -10,
    [4, 5] => -10,
    [5, 5] => -10,
    [6, 5] => -10,
    [7, 5] => 10,
    [0, 6] => 10,
    [1, 6] => -5, 
    [2, 6] => 0,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => -5,
    [7, 6] => 10,
    [0, 7] => 20,
    [1, 7] => 10,
    [2, 7] => 10,
    [3, 7] => 10,
    [4, 7] => 10,
    [5, 7] => 10,
    [6, 7] => 10,
    [7, 7] => 20,
  }.freeze

  WHITE_KNIGHT_TABLE = {
    [0, 0] => -50,
    [1, 0] => -40,
    [2, 0] => -30,
    [3, 0] => -30,
    [4, 0] => -30,
    [5, 0] => -30,
    [6, 0] => -40,
    [7, 0] => -50,
    [0, 1] => -40,
    [1, 1] => -20,
    [2, 1] => 0,
    [3, 1] => 5,
    [4, 1] => 5,
    [5, 1] => 0,
    [6, 1] => -20,
    [7, 1] => -40,
    [0, 2] => -30,
    [1, 2] => 5,
    [2, 2] => 10,
    [3, 2] => 15,
    [4, 2] => 15,
    [5, 2] => 10, 
    [6, 2] => 5,
    [7, 2] => -30,
    [0, 3] => -30,
    [1, 3] => 0,
    [2, 3] => 15,
    [3, 3] => 20,
    [4, 3] => 20,
    [5, 3] => 15,
    [6, 3] => 0,
    [7, 3] => -30,
    [0, 4] => -30,
    [1, 4] => 5,
    [2, 4] => 15,
    [3, 4] => 20,
    [4, 4] => 20,
    [5, 4] => 15,
    [6, 4] => 5,
    [7, 4] => -30,
    [0, 5] => -30,
    [1, 5] => 0,
    [2, 5] => 10,
    [3, 5] => 15,
    [4, 5] => 15,
    [5, 5] => 10, 
    [6, 5] => 0,
    [7, 5] => -30,
    [0, 6] => -40,
    [1, 6] => -20,
    [2, 6] => 0,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => -20,
    [7, 6] => -40,
    [0, 7] => -50,
    [1, 7] => -40,
    [2, 7] => -30,
    [3, 7] => -30,
    [4, 7] => -30,
    [5, 7] => -30,
    [6, 7] => -40,
    [7, 7] => -50,
  }.freeze

  # subtract!
  BLACK_KNIGHT_TABLE = {
    [0, 0] => -50,
    [1, 0] => -40,
    [2, 0] => -30,
    [3, 0] => -30,
    [4, 0] => -30,
    [5, 0] => -30,
    [6, 0] => -40,
    [7, 0] => -50,
    [0, 1] => -40,
    [1, 1] => -20,
    [2, 1] => 0,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => -20,
    [7, 1] => -40,
    [0, 2] => -30,
    [1, 2] => 0,
    [2, 2] => 10,
    [3, 2] => 15,
    [4, 2] => 15,
    [5, 2] => 10, 
    [6, 2] => 0,
    [7, 2] => -30,
    [0, 3] => -30,
    [1, 3] => 5,
    [2, 3] => 15,
    [3, 3] => 20,
    [4, 3] => 20,
    [5, 3] => 15,
    [6, 3] => 5,
    [7, 3] => -30,
    [0, 4] => -30,
    [1, 4] => 0,
    [2, 4] => 15,
    [3, 4] => 20,
    [4, 4] => 20,
    [5, 4] => 15,
    [6, 4] => 0,
    [7, 4] => -30,
    [0, 5] => -30,
    [1, 5] => 5,
    [2, 5] => 10,
    [3, 5] => 15,
    [4, 5] => 15,
    [5, 5] => 10, 
    [6, 5] => 5,
    [7, 5] => -30,
    [0, 6] => -40,
    [1, 6] => -20,
    [2, 6] => 0,
    [3, 6] => 5,
    [4, 6] => 5,
    [5, 6] => 0,
    [6, 6] => -20,
    [7, 6] => -40,
    [0, 7] => -50,
    [1, 7] => -40,
    [2, 7] => -30,
    [3, 7] => -30,
    [4, 7] => -30,
    [5, 7] => -30,
    [6, 7] => -40,
    [7, 7] => -50,
  }.freeze

  WHITE_ROOK_TABLE = {
    [0, 0] => 0,
    [1, 0] => 0,
    [2, 0] => 0,
    [3, 0] => 5,
    [4, 0] => 5,
    [5, 0] => 0,
    [6, 0] => 0,
    [7, 0] => 0,
    [0, 1] => -5,
    [1, 1] => 0,
    [2, 1] => 0,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => 0,
    [7, 1] => -5,
    [0, 2] => -5,
    [1, 2] => 0,
    [2, 2] => 0,
    [3, 2] => 0,
    [4, 2] => 0,
    [5, 2] => 0,
    [6, 2] => 0,
    [7, 2] => -5,
    [0, 3] => -5,
    [1, 3] => 0,
    [2, 3] => 0,
    [3, 3] => 0,
    [4, 3] => 0,
    [5, 3] => 0,
    [6, 3] => 0,
    [7, 3] => -5,
    [0, 4] => -5,
    [1, 4] => 0,
    [2, 4] => 0,
    [3, 4] => 0,
    [4, 4] => 0,
    [5, 4] => 0,
    [6, 4] => 0,
    [7, 4] => -5,
    [0, 5] => -5,
    [1, 5] => 0,
    [2, 5] => 0,
    [3, 5] => 0,
    [4, 5] => 0,
    [5, 5] => 0,
    [6, 5] => 0,
    [7, 5] => -5,
    [0, 6] => 5,
    [1, 6] => 10,
    [2, 6] => 10,
    [3, 6] => 10,
    [4, 6] => 10,
    [5, 6] => 10,
    [6, 6] => 10,
    [7, 6] => 5,
    [0, 7] => 0,
    [1, 7] => 0,
    [2, 7] => 0,
    [3, 7] => 0,
    [4, 7] => 0,
    [5, 7] => 0,
    [6, 7] => 0,
    [7, 7] => 0
  }.freeze

  BLACK_ROOK_TABLE = {
    [0, 0] => 0,
    [1, 0] => 0,
    [2, 0] => 0,
    [3, 0] => 0,
    [4, 0] => 0,
    [5, 0] => 0,
    [6, 0] => 0,
    [7, 0] => 0,
    [0, 1] => 5,
    [1, 1] => 10,
    [2, 1] => 10,
    [3, 1] => 10,
    [4, 1] => 10,
    [5, 1] => 10,
    [6, 1] => 10,
    [7, 1] => 5,
    [0, 2] => -5,
    [1, 2] => 0,
    [2, 2] => 0,
    [3, 2] => 0,
    [4, 2] => 0,
    [5, 2] => 0,
    [6, 2] => 0,
    [7, 2] => -5,
    [0, 3] => -5,
    [1, 3] => 0,
    [2, 3] => 0,
    [3, 3] => 0,
    [4, 3] => 0,
    [5, 3] => 0,
    [6, 3] => 0,
    [7, 3] => -5,
    [0, 4] => -5,
    [1, 4] => 0,
    [2, 4] => 0,
    [3, 4] => 0,
    [4, 4] => 0,
    [5, 4] => 0,
    [6, 4] => 0,
    [7, 4] => -5,
    [0, 5] => -5,
    [1, 5] => 0,
    [2, 5] => 0,
    [3, 5] => 0,
    [4, 5] => 0,
    [5, 5] => 0,
    [6, 5] => 0,
    [7, 5] => 0,
    [0, 6] => -5,
    [1, 6] => 0,
    [2, 6] => 0,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => 0,
    [7, 6] => -5,
    [0, 7] => 0,
    [1, 7] => 0,
    [2, 7] => 0,
    [3, 7] => 5,
    [4, 7] => 5,
    [5, 7] => 0,
    [6, 7] => 0,
    [7, 7] => 0
  }.freeze

  WHITE_QUEEN_TABLE = {
    [0, 0] => -20,
    [1, 0] => -10,
    [2, 0] => -10,
    [3, 0] => -5,
    [4, 0] => -5,
    [5, 0] => -10,
    [6, 0] => -10,
    [7, 0] => -20,
    [0, 1] => -10,
    [1, 1] => 0,
    [2, 1] => 5,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => 0,
    [7, 1] => -10,
    [0, 2] => -10,
    [1, 2] => 5,
    [2, 2] => 5,
    [3, 2] => 5,
    [4, 2] => 5,
    [5, 2] => 5,
    [6, 2] => 0,
    [7, 2] => -10,
    [0, 3] => 0,
    [1, 3] => 0,
    [2, 3] => 5,
    [3, 3] => 5,
    [4, 3] => 5,
    [5, 3] => 5,
    [6, 3] => 0,
    [7, 3] => -5,
    [0, 4] => -5,
    [1, 4] => 0,
    [2, 4] => 5,
    [3, 4] => 5,
    [4, 4] => 5,
    [5, 4] => 5,
    [6, 4] => 0,
    [7, 4] => -5,
    [0, 5] => -10,
    [1, 5] => 0,
    [2, 5] => 5,
    [3, 5] => 5,
    [4, 5] => 5,
    [5, 5] => 5,
    [6, 5] => 0,
    [7, 5] => -10,
    [0, 6] => -10,
    [1, 6] => 0,
    [2, 6] => 0,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => 0,
    [7, 6] => -10,
    [0, 7] => -20,
    [1, 7] => -10,
    [2, 7] => -10,
    [3, 7] => -5,
    [4, 7] => -5,
    [5, 7] => -10,
    [6, 7] => -10,
    [7, 7] => -20
  }.freeze

  # subtract
  BLACK_QUEEN_TABLE = {
    [0, 7] => -20,
    [1, 7] => -10,
    [2, 7] => -10,
    [3, 7] => -5,
    [4, 7] => -5,
    [5, 7] => -10,
    [6, 7] => -10,
    [7, 7] => -20,
    [0, 6] => -10,
    [1, 6] => 0,
    [2, 6] => 5,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => 0,
    [7, 6] => -10,
    [0, 5] => -10,
    [1, 5] => 5,
    [2, 5] => 5,
    [3, 5] => 5,
    [4, 5] => 5,
    [5, 5] => 5,
    [6, 5] => 0,
    [7, 5] => -10,
    [0, 4] => 0,
    [1, 4] => 0,
    [2, 4] => 5,
    [3, 4] => 5,
    [4, 4] => 5,
    [5, 4] => 5,
    [6, 4] => 0,
    [7, 4] => -5,
    [0, 3] => -5,
    [1, 3] => 0,
    [2, 3] => 5,
    [3, 3] => 5,
    [4, 3] => 5,
    [5, 3] => 5,
    [6, 3] => 0,
    [7, 3] => -5,
    [0, 2] => -10,
    [1, 2] => 0,
    [2, 2] => 5,
    [3, 2] => 5,
    [4, 2] => 5,
    [5, 2] => 5,
    [6, 2] => 0,
    [7, 2] => -10,
    [0, 1] => -10,
    [1, 1] => 0,
    [2, 1] => 0,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => 0,
    [7, 1] => -10,
    [0, 0] => -20,
    [1, 0] => -10,
    [2, 0] => -10,
    [3, 0] => -5,
    [4, 0] => -5,
    [5, 0] => -10,
    [6, 0] => -10,
    [7, 0] => -20
  }.freeze

  WHITE_KING_MIDDLE = {
    [0, 0] => 20,
    [1, 0] => 30,
    [2, 0] => 10,
    [3, 0] => 0,
    [4, 0] => 0,
    [5, 0] => 10,
    [6, 0] => 30,
    [7, 0] => 20,
    [0, 1] => 20,
    [1, 1] => 20,
    [2, 1] => 0,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => 20,
    [7, 1] => 20,
    [0, 2] => -10,
    [1, 2] => -20,
    [2, 2] => -20,
    [3, 2] => -20,
    [4, 2] => -20,
    [5, 2] => -20,
    [6, 2] => -20,
    [7, 2] => -10,
    [0, 3] => -20,
    [1, 3] => -30,
    [2, 3] => -20,
    [3, 3] => -40,
    [4, 3] => -40,
    [5, 3] => -30,
    [6, 3] => -30,
    [7, 3] => -20,
    [0, 4] => -30,
    [1, 4] => -40,
    [2, 4] => -40,
    [3, 4] => -50,
    [4, 4] => -50,
    [5, 4] => -40,
    [6, 4] => -40,
    [7, 4] => -30,
    [0, 5] => -30,
    [1, 5] => -40,
    [2, 5] => -40,
    [3, 5] => -50,
    [4, 5] => -50,
    [5, 5] => -40,
    [6, 5] => -40,
    [7, 5] => -30,
    [0, 6] => -30,
    [1, 6] => -40,
    [2, 6] => -40,
    [3, 6] => -50,
    [4, 6] => -50,
    [5, 6] => -40,
    [6, 6] => -40,
    [7, 6] => -30,
    [0, 7] => -30,
    [1, 7] => -40,
    [2, 7] => -40,
    [3, 7] => -50,
    [4, 7] => -50,
    [5, 7] => -40,
    [6, 7] => -40,
    [7, 7] => -30
  }.freeze

  # subtract
  BLACK_KING_MIDDLE = {
    [0, 7] => 20,
    [1, 7] => 30,
    [2, 7] => 10,
    [3, 7] => 0,
    [4, 7] => 0,
    [5, 7] => 10,
    [6, 7] => 30,
    [7, 7] => 20,
    [0, 6] => 20,
    [1, 6] => 20,
    [2, 6] => 0,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => 20,
    [7, 6] => 20,
    [0, 5] => -10,
    [1, 5] => -20,
    [2, 5] => -20,
    [3, 5] => -20,
    [4, 5] => -20,
    [5, 5] => -20,
    [6, 5] => -20,
    [7, 5] => -10,
    [0, 4] => -20,
    [1, 4] => -30,
    [2, 4] => -20,
    [3, 4] => -40,
    [4, 4] => -40,
    [5, 4] => -30,
    [6, 4] => -30,
    [7, 4] => -20,
    [0, 3] => -30,
    [1, 3] => -40,
    [2, 3] => -40,
    [3, 3] => -50,
    [4, 3] => -50,
    [5, 3] => -40,
    [6, 3] => -40,
    [7, 3] => -30,
    [0, 2] => -30,
    [1, 2] => -40,
    [2, 2] => -40,
    [3, 2] => -50,
    [4, 2] => -50,
    [5, 2] => -40,
    [6, 2] => -40,
    [7, 2] => -30,
    [0, 1] => -30,
    [1, 1] => -40,
    [2, 1] => -40,
    [3, 1] => -50,
    [4, 1] => -50,
    [5, 1] => -40,
    [6, 1] => -40,
    [7, 1] => -30,
    [0, 0] => -30,
    [1, 0] => -40,
    [2, 0] => -40,
    [3, 0] => -50,
    [4, 0] => -50,
    [5, 0] => -40,
    [6, 0] => -40,
    [7, 0] => -30
  }.freeze

  WHITE_KING_END = {
    [0, 0] => -50,
    [1, 0] => -30,
    [2, 0] => -30,
    [3, 0] => -30,
    [4, 0] => -30,
    [5, 0] => -30,
    [6, 0] => -30,
    [7, 0] => -50,
    [0, 1] => -30,
    [1, 1] => -30,
    [2, 1] => 0,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => 0,
    [6, 1] => -30,
    [7, 1] => -30,
    [0, 2] => -30,
    [1, 2] => -10,
    [2, 2] => 20,
    [3, 2] => 30,
    [4, 2] => 30,
    [5, 2] => 20,
    [6, 2] => -10,
    [7, 2] => -30,
    [0, 3] => -30,
    [1, 3] => -10,
    [2, 3] => 30,
    [3, 3] => 40,
    [4, 3] => 40,
    [5, 3] => 30,
    [6, 3] => -10,
    [7, 3] => -30,
    [0, 4] => -30,
    [1, 4] => -10,
    [2, 4] => 30,
    [3, 4] => 40,
    [4, 4] => 40,
    [5, 4] => 30,
    [6, 4] => -10,
    [7, 4] => -30,
    [0, 5] => -30,
    [1, 5] => -10,
    [2, 5] => 20,
    [3, 5] => 30,
    [4, 5] => 30,
    [5, 5] => 20,
    [6, 5] => -10,
    [7, 5] => -30,
    [0, 6] => -30,
    [1, 6] => -20,
    [2, 6] => -10,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => -10,
    [6, 6] => -20,
    [7, 6] => -30,
    [0, 7] => -50,
    [1, 7] => -40,
    [2, 7] => -30,
    [3, 7] => -20,
    [4, 7] => -20,
    [5, 7] => -30,
    [6, 7] => -40,
    [7, 7] => -50
  }.freeze

  # subtract
  BLACK_KING_END = {
    [0, 7] => -50,
    [1, 7] => -30,
    [2, 7] => -30,
    [3, 7] => -30,
    [4, 7] => -30,
    [5, 7] => -30,
    [6, 7] => -30,
    [7, 7] => -50,
    [0, 6] => -30,
    [1, 6] => -30,
    [2, 6] => 0,
    [3, 6] => 0,
    [4, 6] => 0,
    [5, 6] => 0,
    [6, 6] => -30,
    [7, 6] => -30,
    [0, 5] => -30,
    [1, 5] => -10,
    [2, 5] => 20,
    [3, 5] => 30,
    [4, 5] => 30,
    [5, 5] => 20,
    [6, 5] => -10,
    [7, 5] => -30,
    [0, 4] => -30,
    [1, 4] => -10,
    [2, 4] => 30,
    [3, 4] => 40,
    [4, 4] => 40,
    [5, 4] => 30,
    [6, 4] => -10,
    [7, 4] => -30,
    [0, 3] => -30,
    [1, 3] => -10,
    [2, 3] => 30,
    [3, 3] => 40,
    [4, 3] => 40,
    [5, 3] => 30,
    [6, 3] => -10,
    [7, 3] => -30,
    [0, 2] => -30,
    [1, 2] => -10,
    [2, 2] => 20,
    [3, 2] => 30,
    [4, 2] => 30,
    [5, 2] => 20,
    [6, 2] => -10,
    [7, 2] => -30,
    [0, 1] => -30,
    [1, 1] => -20,
    [2, 1] => -10,
    [3, 1] => 0,
    [4, 1] => 0,
    [5, 1] => -10,
    [6, 1] => -20,
    [7, 1] => -30,
    [0, 0] => -50,
    [1, 0] => -40,
    [2, 0] => -30,
    [3, 0] => -20,
    [4, 0] => -20,
    [5, 0] => -30,
    [6, 0] => -40,
    [7, 0] => -50
  }.freeze
end