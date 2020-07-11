require_relative 'board'

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

# move 14... (main line semi-slav)

board.benchmark