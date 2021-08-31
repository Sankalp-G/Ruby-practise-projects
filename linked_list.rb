# class representing one node
class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end

# class representing entire list
class LinkedList
  attr_reader :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    newnode = Node.new(value)
    if @head.nil?
      @head = newnode
    else
      @tail.next_node = newnode
    end
    @tail = newnode
    @tail
  end

  def prepend(value)
    newnode = Node.new(value)
    if @head.nil?
      @tail = newnode
    else
      newnode.next_node = @head
    end
    @head = newnode
    @head
  end

  def size
    return nil if @head.nil?

    result = 0
    node = @head
    until node.nil?
      result += 1
      node = node.next_node
    end
    result
  end

  def at(index)
    return nil if index < 0

    node = @head
    i = 0
    while i < index
      return nil if node.nil?
      node = node.next_node
      i += 1
    end
    node
  end

  def pop
    oldtail = @tail
    if @tail == @head
      @tail = nil
      @head = nil
      return oldtail
    end
    node = @head
    until node.next_node.next_node.nil?
      node = node.next_node
    end
    node.next_node = nil
    @tail = node
    oldtail
  end

  def contains?(value)
    node = @head
    until node.nil? || node.value == value
      node = node.next_node
    end
    if node.nil?
      false
    else
      true
    end
  end

  def find(value)
    index = 0
    node = @head
    until node.nil? || node.value == value
      node = node.next_node
      index += 1
    end
    if node.nil?
      nil
    else
      index
    end
  end

  def to_s
    return nil if @head.nil?

    output = []
    node = @head
    until node.nil?
      output.push(node.value)
      node = node.next_node
    end
    ['( ', output.join(' ) -> ( '), ' ) -> nil'].join
  end

  # returns nil if index is invalid and inserts at the end if index larger than size
  def insert_at(value, index)
    return nil if index.negative?

    i = 0
    previousnode = nil
    node = @head
    while i < index && !node.nil?
      previousnode = node
      node = node.next_node
      i += 1
    end
    newnode = Node.new(value)
    if node.nil?
      if previousnode.nil?
        @head = newnode
        @tail = newnode
        return newnode
      end
      previousnode.next_node = newnode
    else
      previousnode.next_node = newnode
      newnode.next_node = node
    end
    newnode
  end

  # returns nil if index is invalid
  def remove_at(index)
    return nil if index < 0

    i = 0
    previousnode = nil
    node = @head
    while i < index && !node.nil?
      previousnode = node
      node = node.next_node
      i += 1
    end
    return nil if node.nil?

    previousnode.next_node = node.next_node
    node
  end
end
