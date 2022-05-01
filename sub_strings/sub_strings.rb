def substrings (string, dictionary)
  string = string.downcase
  num_of_occurances = {}
  dictionary.each do |word|
    if string.include?(word)
      occurances = string.scan(word)
      num_of_occurances[word] = occurances.length
    end
  end
  num_of_occurances
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

puts substrings("Howdy partner, sit down! How's it going?", dictionary)