def stock_picker(stock_price)

  #returns array with day1, day2, difference in price
  priced = []
  stock_price.each_with_index do |val, index|
    stock_price.each_with_index do |val2, index2|
      priced.push([index, index2, val2 - val])
    end
  end

  sorted = priced.sort() {|a, b| -(a[2] <=> b[2])}

  #returns first value with day1 less than day2
  i = 0
  result = []
  while true
    if sorted[i][0] < sorted[i][1]
      result.push(sorted[i][0])
      result.push(sorted[i][1])
      break
    end
    i += 1
  end

  return result
end

p stock_picker([17,3,6,9,15,8,6,1,10])