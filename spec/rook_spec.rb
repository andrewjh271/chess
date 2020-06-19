require './lib/rook.rb'

describe Rook do
  describe '.moves' do
    it 'returns all possible moves from a given set of coordinates' do
      expect(Rook.moves([0, 3])).to contain_exactly(
        [0, -4], [0, -3], [0, -2], [0, -1], [0, 0], [0, 1], [0, 2],
        [0, 4], [0, 5], [0, 6], [0, 7], [0, 8], [0, 9], [0, 10],
        [-7, 3], [-6, 3], [-5, 3], [-4, 3], [-3, 3], [-2, 3], [-1, 3],
        [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3]
      )
    end
  end
end