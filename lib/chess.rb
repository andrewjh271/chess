require_relative 'board'
require_relative 'knight'

board = Board.new
board.display

# knight1 = WhiteKnight.new
# puts knight1.white?

# knight2 = BlackKnight.new
# puts knight2.white?

print 'exe4: '
board.move('exe4')
puts
print 'hxe4: '
board.move('hxe4')
puts
print 'Nxe4'
board.move('Nxe4')
puts
print 'Na3'
board.move('Na3')
puts
print 'e4: '
board.move('e4')
puts