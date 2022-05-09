require 'pry-byebug'

# game class
class TicTacToe
  private

  def initialize
    @blank_tile = ['...........', '.         .', '.         .', '.         .', '...........']
    @x_tile = ['...........', '.  x   x  .', '.    x    .', '.  x   x  .', '...........']
    @o_tile = ['...........', '.  o o o  .', '.  o   o  .', '.  o o o  .', '...........']
    @coords = [['', '', ''], ['', '', ''], ['', '', '']]
  end

  def draw_board
    board = []
    @coords.each do |row|
      (0..4).each do |i|
        intermediate = ''
        row.each do |val|
          case val
          when ''
            intermediate.concat(@blank_tile[i])
          when 'x'
            intermediate.concat(@x_tile[i])
          when 'o'
            intermediate.concat(@o_tile[i])
          end
        end
        board.push(intermediate)
      end
    end
    board
  end

  # get player move and verify if its a legal move
  def play_move(player)
    raise 'Player isnt x or o' unless %w[x o].include?(player)

    in_coords = gets.chomp.split(' ')
    in_coords.map!(&:to_i)

    # check if its within 1 and 3
    in_coords.each do |coord|
      raise "invalid coord: #{coord}, Try again" if coord > 3 || coord < 1
    end
    # check if given spot is available
    raise 'spot already occupied, Try again' unless @coords[in_coords[0] - 1][in_coords[1] - 1] == ''

    # update coord board
    @coords[in_coords[0] - 1][in_coords[1] - 1] = player
  rescue StandardError => e
    puts e
    retry
  end

  def win_condition
    @coords.each do |row|
      # row check
      return row[0] if row.all?('x') || row.all?('o')
    end
    (0..2).each do |i|
      # collumn check
      return @coords[0][i] if @coords[0][i] == @coords[1][i] && @coords[1][i] == @coords[2][i] && @coords[0][i] != ''
    end
    # diagonal check
    return @coords[0][0] if @coords[0][0] == @coords[1][1] && @coords[1][1] == @coords[2][2] && @coords[0][0] != ''
    return @coords[0][2] if @coords[0][2] == @coords[1][1] && @coords[1][1] == @coords[2][0] && @coords[0][2] != ''

    return 'tie' if !@coords.flatten.include?('') && !@coords.flatten.all?('')

    false
  end

  public

  def start_game(starting_player = 'x')
    player = starting_player
    until win_condition
      puts draw_board
      puts "player #{player} play your move!"
      play_move(player)
      player == 'x' ? player = 'o' : player = 'x'
    end
    if win_condition == 'tie'
      puts draw_board
      puts 'ITS A TIE!'
    else
      puts "#{win_condition} WON THE GAME!!!"
    end
  end
end

new_board = TicTacToe.new

new_board.start_game
