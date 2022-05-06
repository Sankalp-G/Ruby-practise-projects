# recreation of various Enumerable methods
module Enumerable
  def my_each
    i = 0
    self_arr = self.to_a
    while i < self_arr.length
      yield self_arr[i]
      i += 1
    end
    self
  end

  def my_each_with_index
    i = 0
    self_arr = self.to_a
    while i < self_arr.length
      yield self_arr[i], i
      i += 1
    end
    self
  end

  def my_select
    result = []
    self.my_each do |item|
      result.push(item) if yield item
    end
    result
  end

  def my_all?
    self.my_each do |item|
      return false if (yield item) == false
    end
    true
  end

  def my_any?
    self.my_each do |item|
      return true if yield item
    end
    false
  end

  def my_none?
    self.my_each do |item|
      return false if yield item
    end
    true
  end

  def my_count
    count = 0
    self.my_each do |item|
      count += 1 if yield item
    end
    count
  end

  def my_map(proc=nil)
    result = []
    self.my_each do |item|
      unless proc.nil?
        result.push(proc.call(item))
      else
        result.push(yield item)
      end
    end
    result
  end

  def my_inject(initial=nil)
    total = nil
    unless initial.nil?
      total = initial
    end
    self.my_each do |item|
      if total.nil?
        total = self.to_a[0]
        next
      end
      total = yield(total, item)
    end
    total
  end
end

def multiply_els(arr)
  arr.my_inject do |tot, num|
    tot * num
  end
end
