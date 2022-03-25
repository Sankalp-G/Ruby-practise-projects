# makes sure number is between 24
def rollover26(num)
  num -= 26 while num >= 26

  num
end

def caesar_cipher(string, shift_amt)
  throw 'invalid shift ammount, must be positive integer' if !shift_amt.is_a?(Integer) || shift_amt.negative?

  shift_amt = rollover26(shift_amt)

  result = ''
  string_array = string.split('')

  # loop through each letter and append ciphered letter to result
  string_array.each do |letter|
    letter_ord = letter.ord

    result_ord = shift_amt + letter_ord

    # if lowercase
    if letter_ord.between?(97, 122)
      result_ord -= 26 if result_ord > 122
    # if uppercase
    elsif letter_ord.between?(66, 90)
      result_ord -= 26 if result_ord > 90
    # if not an alphabet
    else
      result << letter_ord.chr
      next
    end

    result << result_ord.chr
  end

  result
end
