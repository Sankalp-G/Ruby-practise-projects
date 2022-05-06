def substrings(string, dictionary)
  string = string.downcase
  num_of_occurrences = {}
  dictionary.each do |word|
    if string.include?(word)
      occurrences = string.scan(word)
      num_of_occurrences[word] = occurrences.length
    end
  end
  num_of_occurrences
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

puts substrings("Howdy partner, sit down! How's it going?", dictionary)
