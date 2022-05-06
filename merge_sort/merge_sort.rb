numbers = 100.times.map{ rand(100) }

def merge_sort(array)
  return array[0] if array.to_a.length <= 1

  result = []

  sliced = array.each_slice((array.size / 2.0).round).to_a

  left = merge_sort(sliced[0])
  right = merge_sort(sliced[1])

  left = [left] if left.instance_of?(Integer)
  right = [right] if right.instance_of?(Integer)

  until (left + right).empty?
    if right[0].nil?
      result.push(left[0])
      left.delete_at(0)
    elsif left[0].nil?
      result.push(right[0])
      right.delete_at(0)
    elsif left[0] <= right[0]
      result.push(left[0])
      left.delete_at(0)
    else
      result.push(right[0])
      right.delete_at(0)
    end
  end
  result
end

p merge_sort(numbers)
