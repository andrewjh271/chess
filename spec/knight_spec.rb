require './lib/knight.rb'

describe Knight do
  describe '.moves' do
    it 'returns all possible moves from a given set of coordinates' do
      expect(Knight.moves([3, 2])).to contain_exactly(
        [4, 4], [5, 3], [5, 1], [4, 0],
        [2, 0], [1, 1], [1, 3], [2, 4]
      )
    end
  end
end