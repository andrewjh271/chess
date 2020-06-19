require './lib/king.rb'

describe King do
  describe '.moves' do
    it 'returns all possible moves from a given set of coordinates' do
      expect(King.moves([3, 2])).to contain_exactly(
        [3, 3], [4, 3], [4, 2], [4, 1],
        [3, 1], [2, 1], [2, 2], [2, 3]
      )
    end
  end
end