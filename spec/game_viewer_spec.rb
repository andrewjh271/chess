require './lib/game_viewer.rb'

class Tester
  include GameViewer
end

describe GameViewer do
  describe '#load_games' do
    it 'loads game' do
      tester = Tester.new
      allow(tester).to receive(:choose_collection).and_return('/collections/SaintLouis2019.pgn')
      expect(tester.load_games["7) \e[36mLenderman\e[0m vs \e[34mNakamura\e[0m 2019.03.21"]).to eq(
          %w[d4 d5 Nf3 Nf6 c4 dxc4 e3 e6 Bxc4 c5 O-O a6 b3 cxd4 Nxd4 Be7 Bb2 O-O Nd2 b5 Be2
          Bb7 Bf3 Ra7 Rc1 Qd7 Bxb7 Rxb7 N2f3 Rc7 Rxc7 Qxc7 Qb1 Qb7 Rc1 Rc8 Ne5 Nfd7 Ndf3
          Nxe5 Nxe5 Nd7 Nxd7 Rxc1+ Qxc1 Qxd7 Qc2 f6 g3 e5 e4 Kf7 Bc1 Bd6 Be3 Qc7 Qxc7+ Bxc7
          Kf1 Ke6 1/2-1/2]
      )
    end
  end
end