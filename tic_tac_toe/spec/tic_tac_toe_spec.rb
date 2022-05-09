require_relative '../lib/tic_tac_toe'

describe TicTacToe do
  subject(:game) { described_class.new }

  describe '#play_move' do
    context 'player argument and input is valid' do
      before do
        allow(game).to receive(:gets).and_return("1 2\n")
        allow(game).to receive(:puts)
      end
      it 'places mark on the board' do
        game.play_move('x')
        game_board = game.instance_variable_get(:@coords)
        expected_board = [['', 'x', ''], ['', '', ''], ['', '', '']]
        expect(game_board).to eql(expected_board)
      end
    end

    context 'player argument is invalid' do
      before do
        allow(game).to receive(:puts)
      end
      it 'raises an error' do
        expect{ game.play_move('yellow') }.to raise_error('Player isnt x or o')
      end
    end

    context 'invalid coord twice then valid coord' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return("10 20\n", "2 5\n", "3 2\n")
      end
      it 'retries twice' do
        expect(game).to receive(:gets).thrice
        game.play_move('x')
      end
    end

    context 'marker is attempted to be placed on an occupied spot thrice then valid spot' do
      before do
        game.instance_variable_set(:@coords, [['x', '', ''], ['', '', ''], ['', '', '']])
        allow(game).to receive(:puts)
        allow(game).to receive(:gets).and_return("1 1\n", "1 1\n", "1 1\n", "1 2\n")
      end
      it 'retries thrice' do
        expect(game).to receive(:gets).exactly(4).times
        game.play_move('o')
      end
    end
  end

  describe '#win_condition' do
    context 'no consecutive elements' do
      it 'returns false' do
        game.instance_variable_set(:@coords, [['o', '', 'x'], ['', 'o', 'x'], ['x', '', '']])

        expect(game.win_condition).to eql(false)
      end
    end

    context '3 consecutive in row' do
      it 'returns consecutive element' do
        game.instance_variable_set(:@coords, [%w[x x x], ['', '', ''], ['', '', '']])

        expect(game.win_condition).to eql('x')
      end
    end

    context '3 consecutive in column' do
      it 'returns consecutive element' do
        game.instance_variable_set(:@coords, [['', '', 'o'], ['', '', 'o'], ['', '', 'o']])

        expect(game.win_condition).to eql('o')
      end
    end

    context '3 consecutive in diagonal' do
      it 'returns consecutive element' do
        game.instance_variable_set(:@coords, [['', '', 'o'], ['', 'o', ''], ['o', '', '']])

        expect(game.win_condition).to eql('o')
      end
    end
  end

  describe '#start_game' do
    context 'game is won after 4 turns' do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:play_move)
        allow(game).to receive(:win_condition).and_return(false, false, false, false, 'x')
      end
      it 'calls #play_move 4 times' do
        expect(game).to receive(:play_move).exactly(4).times
        game.start_game
      end
    end
  end
end
