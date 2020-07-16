require './lib/board.rb'
require './lib/game.rb'
require './lib/human.rb'
require './lib/computer.rb'

# tests SaveLoad module using Game class; excludes methods w/ user input
describe SaveLoad do
  after(:all) { File.delete(File.join(Dir.pwd, '/saved/test.yaml')) }

  describe '#save' do
    it 'saves a game' do
      game = Game.new(Human.new('White'), Computer.new('Black'))
      allow(game).to receive(:prompt_name).and_return('test')
      game.board.move('e4')
      game.board.move('e5')
      game.board.move('Bc4')
      game.board.move('Bc5')
      game.board.move('Nf3')
      game.board.move('Nf6')
      game.board.move('Ke2')
      game.board.move('Nc6')
      game.board.move('Ke1')
      game.board.move('Nb8')
      # first (threefold repetition count)
      game.board.move('Ke2')
      game.board.move('Ng4')
      game.board.move('Ke1')
      game.board.move('Nf6')
      # second
      game.board.move('Na3')
      game.board.move('Bb6')
      game.board.move('Nb1')

      expect(game.save_game(game)).to be_truthy
    end
  end

  describe '#load' do
    game = Game.new(nil, nil)
    # normally, Main also extends SaveLoad and calls #load
    it 'loads a game' do
      allow(game).to receive(:choose_game).and_return('/saved/test.yaml')
      game = game.load_game
    end

    it 'still finds threefold repetition' do
      game.board.move('Bc5')
      # third
      expect(game.board).to be_over
    end

    it 'enforces castling rules' do
      # white cannot castle
      expect(game.board.move('O-O')).to eq(false)
    end

    it 'preserves castling rights' do
      game.board.move('d3')
      # black can castle
      expect(game.board.move('O-O')).to eq(true)
    end

    it 'preserves whether Human or Computer is playing' do
      expect(game.white).to be_a(Human)
      expect(game.black).to be_a(Computer)
    end
  end
end
