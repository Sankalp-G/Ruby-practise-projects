def rollover24(num)
  while num > 24
    num -= 24
  end
  return num
end

def caesar_cipher(string, shift_amt)
  str_template_downcase = []
  ('a'..'z').each {|letter| str_template_downcase.push(letter)}

  str_template_upcase = []
  ('A'..'Z').each {|letter| str_template_upcase.push(letter)}

  chars = string.split("")

  shift_amt = rollover24(shift_amt)

  cipher = []

  chars.each do |char|
    if char.between?('a', 'z')
      true_index = rollover24(str_template_downcase.index(char) + shift_amt)
      cipher.push(str_template_downcase[true_index])

    elsif char.between?('A', 'Z')
      true_index = rolliver24(str_template_upcase.index(char) + shift_amt)
      cipher.push(str_template_upcase[true_index])

    else
      cipher.push(char)

    end
  end
  return cipher.join("")
end

puts caesar_cipher('!boop', 25)
