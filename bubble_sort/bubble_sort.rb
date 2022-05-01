
def bubble_sort(array)
  intermediate = array.dup
  output = array.dup
  condition = true
  while condition
    # arranging
    i = 0
    while i < array.length - 1
      if output[i] > output[i + 1]
        intermediate[i] = output[i + 1]
        intermediate[i + 1] = output[i]
      end
      output = intermediate.dup
      i += 1
    end

    # checking if the order for everything is right
    i2 = 0
    condition = false
    while i2 < array.length - 1
      if output[i2] > output[i2 + 1]
        condition = true
      end
      i2 += 1
    end
  end
  output
end

p bubble_sort([4,3,78,2,0,2])