require './lib/bishop.rb'

describe Bishop do
  describe '.moves' do
    it 'returns all possible moves from a given set of coordinates' do
      expect(Bishop.moves([5, 6])).to contain_exactly(
        [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13],
        [4, 5], [3, 4], [2, 3], [1, 2], [0, 1], [-1, 0], [-2, -1],
        [4, 7], [3, 8], [2, 9], [1, 10], [0, 11], [-1, 12], [-2, 13],
        [6, 5], [7, 4], [8, 3], [9, 2], [10, 1], [11, 0], [12, -1]
      )
    end
  end
end