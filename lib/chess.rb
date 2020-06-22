require_relative 'board'
require_relative 'knight'

board = Board.new
board.display

# knight1 = WhiteKnight.new
# puts knight1.white?

# knight2 = BlackKnight.new
# puts knight2.white?

# print 'exe4: '
# board.move('exe4')
# puts
# print 'hxe4: '
# board.move('hxe4')
# puts
# print 'Nxe4'
# board.move('Nxe4')
# puts
# print 'Na3'
# board.move('Na3')
# puts
print 'd4: '
board.move('d4')
puts
print 'd5: '
board.move('d5')
puts
print 'c4: '
board.move('c4')
puts
print 'Nf6: '
board.move('Nf6')
puts
print 'Nf3'
board.move('Nf3')
puts
print 'dxc4'
board.move('dxc4')
puts
print 'Nbd2: '
board.move('Nbd2')
puts