require 'json'

# hangman game
class Hangman
  def initialize
    @true_word = %w[t e s t]
    @revealed_letter = %w[_ _ _ _]
    @strikes = 0
    @tried_letters = []
    @hangman_ascii = get_ascii('./ascii_hangman')
  end

  # filter the dictionary file to only have word with length 5-12 and output to new file
  def self.filter_dict(dict_path, output_path)
    dict = File.open(dict_path)
    filtered = File.open(output_path, 'w')

    while dict.eof? == false
      word = dict.gets.chomp
      filtered.puts word if word.length.between?(5, 12)
    end
    dict.close
  end

  # get ascii art from file
  def get_ascii(path)
    file = File.read(path)
    file.split(',')
  end

  # get a random word from file
  def get_true_word(list_path)
    list = File.open(list_path)
    line_count = `wc -l "#{list_path}"`.strip.split(' ')[0].to_i
    rand_line_count = rand(1..line_count)
    (rand_line_count - 1).times { list.gets }
    list.gets.chomp.downcase
  end

  # get 1 single letter from user
  def getchar
    input = gets.chomp.downcase
    return 'save' if input == 'save'
    raise 'input must be a single letter' unless input.match(/^[[:alpha:]]$/)
    raise 'you have already guessed this letter' if @tried_letters.include?(input)

    @tried_letters.push(input)
    input
  rescue StandardError => e
    puts "#{e}\ntry again\n\n"
    retry
  end

  # tries to get either 1 or 2 from user
  def getnum
    input = gets.chomp
    raise 'you need to type in either 1 or 2' unless input == '1' || input == '2'

    input.to_i
  rescue StandardError => e
    puts "#{e}\ntry again\n\n"
    retry
  end

  # 'reveals' the letter in revealed array and returns true if char was present else false
  def reveal(char)
    @true_word.each_with_index do |letter, index|
      if letter == char
        @revealed_letter[index] = letter
      end
    end
    @true_word.include?(char)
  end

  def play_move(move)
    if move == 'save'
      save_game
      exit
    else
      @strikes += 1 unless reveal(move)
    end
  end

  # saves game data to a file
  def save_game
    save = {
      true_word: @true_word,
      revealed_letter: @revealed_letter,
      strikes: @strikes,
      tried_letters: @tried_letters
    }
    save_json = JSON.generate(save)
    save_file = File.open('./savefile', 'w')
    save_file.puts(save_json)
    save_file.close
    puts "\nsaved successfully"
  end

  # loads drom a previous savefile
  def load_game
    if File.file?('./savefile') == false
      puts "\ncould not find any previous savefile"
      puts "\nexiting..."
      exit
    end
    load_file = File.open('./savefile')
    load_json = load_file.read
    load_file.close
    load_data = JSON.parse(load_json)
    @true_word = load_data['true_word']
    @revealed_letter = load_data['revealed_letter']
    @strikes = load_data['strikes']
    @tried_letters = load_data['tried_letters']
    puts "\nloaded successfully"
  end

  def start_round
    puts "\n------------------------------"
    puts @hangman_ascii[@strikes]
    puts "strikes: (#{@strikes}/6)    #{@revealed_letter.join(' ')}"
    puts "\ntype in your guess or type 'save' if u want to save the game\n\n"
    play_move(getchar)
  end

  def start_game
    puts "\nWelcome to Hangman! \nIn this game you have to guess the correct word\nbefore you run out of strikes otherwise you're ded"
    puts "\n\nWould you like to start a new game or load a previous save\n\n"
    puts "[1] New game \n[2] Load game\n\n"

    input = getnum
    if input == 1
      @true_word = get_true_word('./filtered.txt').split('')
      @revealed_letter = @true_word.map { '_' }
      @strikes = 0
      @tried_letters = []
    else
      load_game
    end

    while @strikes < 6 || @true_word.eql?(@revealed_letter)
      start_round
    end
    puts "\n------------------------------"
    puts @hangman_ascii[@strikes]
    puts "strikes: (#{@strikes}/6)    #{@revealed_letter.join(' ')}\n\n"
    if @true_word.eql?(@revealed_letter)
      puts 'congrats u managed to survive!'
    else
      puts "welp u died the correct word was #{@true_word.join}"
    end
  end
end

game = Hangman.new

game.start_game
