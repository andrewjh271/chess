require_relative 'board'

# test
board = Board.new

board.move('Nc3')
board.move('Nf6')

board.move('Nf3')
board.move('Nc6')

board.move('e3')
board.move('e6')

board.move('Bb5')
board.move('Bb4')

board.move('a3')
board.move('Bxc3')

board.move('dxc3')
board.move('O-O')

board.move('Bxc6')
board.move('dxc6')

board.move('Qxd8')
board.move('Rxd8')

board.move('Ke2')
board.move('b6')

board.move('Ne5')
board.move('Bb7')

board.move('Re1')
board.move('c5')

board.move('Rg1')
board.move('Be4')

board.move('c4')
board.move('Bxc2')

board.move(board.choose_move(4))
board.display(0)



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