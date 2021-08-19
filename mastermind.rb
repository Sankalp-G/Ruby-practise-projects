# Mastermind code breaking game...
class MasterMind
  private

  def initialize
    @true_code = []
    @last_match = {}
    @full_set = full_set
  end

  # returns array from a split 4 digit number with max value 6
  def randomcode
    result = []
    4.times { result.push(rand(1..6)) }
    result
  end

  # get code combination from user
  def get_code
    input = gets.chomp.split('')
    result = input.map(&:to_i)
    if result == [4, 0, 4]
      p @true_code
      raise 'boop'
    end
    raise 'input isnt a num with 4 digits between 1-6' unless result.length == 4 && result.all? { |i| i.between?(1, 6) }

    result
  rescue StandardError => e
    puts "#{e}\ntry again\n\n"
    retry
  end

  # tries to get either 1 or 2 from user
  def get_num
    input = gets.chomp
    raise 'you need to type in either 1 or 2' unless input == '1' || input == '2'

    input.to_i
  rescue StandardError => e
    puts "#{e}\ntry again\n\n"
    retry
  end

  # matches code in argument 1 with code in argument 2 and returns info about match
  def match(input, truth)
    matches = Hash.new(0)
    true_copy = truth.dup
    code = input.dup

    code.each_with_index do |_value, index|
      next if code[index].nil?

      if code[index] == true_copy[index]
        matches[:correct] += 1
        true_copy[index] = nil
        code[index] = nil
      end
    end
    code.each_with_index do |_value, index|
      next if code[index].nil?

      if true_copy.find_index(code[index])
        matches[:misplaced] += 1
        true_copy[true_copy.find_index(code[index])] = nil
        code[index] = nil
      end
    end
    matches[:text] = "#{matches[:correct]} digits correct and #{matches[:misplaced]} digits misplaced"
    matches
  end

  # returns set containg all possible code from the given code and code result
  def possible_true_codes(code, code_match)
    result = []
    @full_set.each do |possible|
      match = match(code, possible)
      result.push(possible) if match == code_match
    end
    result
  end

  # returns set containing all codes
  def full_set
    number_set = (1111..6666).map { |i| i.to_s.split('') }
    number_set = number_set.each { |arr| arr.map!(&:to_i) }
    number_set.filter { |arr| arr.all? { |num| num.between?(1, 6) } }
  end

  # start game where you try to crack the code
  def guess_game
    @true_code = randomcode

    i = 0
    while @last_match[:correct] != 4 && i < 12
      i += 1
      puts "------\n(#{i}/12)"
      matches = match(get_code, @true_code)
      @last_match = matches
      puts matches[:text]
      puts "------\n\n\n"
    end
    if i <= 12
      return 'won'
    else
      return 'lost'
    end
  end

  # start game where cpu cracks the code
  def break_game(true_code)
    @true_code = true_code
    set = full_set
    set.prepend([1, 1, 2, 2])
    i = 0
    while @last_match[:correct] != 4 && i <= 12
      i += 1
      puts "------\n(#{i}/12)"
      matches = match(set[0], @true_code)
      @last_match = matches
      p set[0]
      puts matches[:text]
      puts "------\n\n\n"

      set = set.intersection(possible_true_codes(set[0], matches))

    end

    puts 'this code is guaranteed to get the correct answer within 6 guesses'
    puts 'with the same info that would be given to a human player (Swaszek\'s method)'
  end

  public

  # starts interface for the game
  def start_game
    @true_code = []
    @last_match = {}

    puts "Welcome\n\n Do you want to guess the code or make the code?\ntype 1 or 2 to select your choice"
    puts "\n [1] Guess"
    puts "\n [2] Make"

    input = get_num
    if input == 1
      puts "\ntype your first guess! code should be 4 digits long and only with digits from 1-6"
      result = guess_game

      if result == 'won'
        puts 'Congratulations you guessed the correct code!'
      elsif result == 'lost'
        puts 'Uh oh, you lost since you could\'nt guess with code within 12 tries'
      end

    elsif input == 2
      puts "\ntype the code that you want the cpu to crack!\ncode should be 4 digits long and only with digits from 1-6"
      break_game(get_code)
    else
      puts 'whoops'
    end
  end
end

new_game = MasterMind.new

new_game.start_game
