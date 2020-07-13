require_relative 'board'

# semi-slav
board = Board.new

board.move('d4')
board.move('d5')

board.move('c4')
board.move('c6')

board.move('Nc3')
board.move('Nf6')

board.move('Nf3')
board.move('e6')

board.move('Bg5')
board.move('h6')

board.move('Bh4')
board.move('dxc4')

board.move('e4')
board.move('g5')

board.move('Bg3')
board.move('b5')

board.move('Be2')
board.move('Bb7')

board.move('e5')
board.move('Nd5')

board.move('Nd2')
board.move('Nd7')

board.move('a4')
board.move('Qb6')

board.move('Nde4')
board.move('a5')

board.benchmark

# Sicilian Najdorf
board = Board.new

board.move('e4')
board.move('c5')

board.move('Nf3')
board.move('d6')

board.move('d4')
board.move('cxd4')

board.move('Nxd4')
board.move('Nf6')

board.move('Nc3')
board.move('a6')

board.move('Be3')
board.move('e5')

board.move('Nb3')
board.move('Be6')

board.move('f3')
board.move('Be7')

board.move('Qd2')

board.benchmark

#Caro-Kann: Advance Variation
board = Board.new

board.move('e4')
board.move('c6')

board.move('d4')
board.move('d5')

board.move('e5')
board.move('Bf5')

board.move('Nf3')
board.move('e6')

board.move('Be2')
board.move('Nd7')

board.move('O-O')
board.move('Ne7')

board.move('Nbd2')
board.move('h6')

board.move('Nb3')
board.move('g5')

board.move('Ne1')
board.move('Qc7')

board.benchmark

#King's Indian
board = Board.new

board.move('d4')
board.move('Nf6')

board.move('c4')
board.move('g6')

board.move('Nc3')
board.move('Bg7')

board.move('e4')
board.move('d6')

board.move('Nf3')
board.move('O-O')

board.move('Be2')
board.move('e5')

board.benchmark