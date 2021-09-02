class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end
end

# creates balanced binary search tree from given array
class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  # feed only sorted array with unique elements returns root node
  def build_tree(array)
    return if array.empty?

    mid = array.size / 2
    new_node = Node.new(array[mid])

    return new_node if array.size == 1

    new_node.left = build_tree(array[0..(mid - 1)])
    new_node.right = build_tree(array[(mid + 1)..array.size])
    new_node
  end

  #inserts node with given value
  def insert(value, current_node = @root)
    raise "tree already contains given value: #{value}" if current_node.data == value

    if current_node.left.nil? && current_node.right.nil?
      if current_node.data < value
        current_node.right = Node.new(value)
      else
        current_node.left = Node.new(value)
      end
      return
    end
    if current_node.data < value
      return current_node.right = Node.new(value) if current_node.right.nil?

      insert(value, current_node.right)
    else
      return current_node.left = Node.new(value) if current_node.left.nil?

      insert(value, current_node.left)
    end
  end

  # only when right child is not empty
  def inorder_succesor(node)
    return nil if node.right.nil?

    inode = node.right
    until inode.left.nil?
      inode = inode.left
    end
    inode
  end

  # deletes node with given value
  def delete(value, current_node = @root, previous_node = nil)
    return nil if current_node.nil?

    if current_node.data == value
      if current_node.left.nil? && current_node.right.nil?
        previous_node.left = nil if previous_node.left == current_node
        previous_node.right = nil if previous_node.right == current_node
      elsif current_node.left.nil? || current_node.right.nil?
        if previous_node.left == current_node
          previous_node.left = current_node.left if current_node.right.nil?
          previous_node.left = current_node.right if current_node.left.nil?
        else
          previous_node.right = current_node.left if current_node.right.nil?
          previous_node.right = current_node.right if current_node.left.nil?
        end
      else
        succesor = inorder_succesor(current_node)
        data = succesor.data
        delete(data)
        current_node.data = data
      end
      return current_node
    end

    return if current_node.left.nil? && current_node.right.nil?

    if current_node.data < value
      delete(value, current_node.right, current_node)
    else
      delete(value, current_node.left, current_node)
    end
  end

  # returns node with given value
  def find(value, current_node = @root)
    return current_node if current_node.data == value
    return nil if current_node.left.nil? && current_node.right.nil?

    if current_node.data < value
      find(value, current_node.right)
    else
      find(value, current_node.left)
    end
  end

  # returns array with tree elements (level order) iteratively
  def level_order_itr(node = @root)
    output = []
    que = [node]
    until que.empty?
      output.push(que[0].data)
      que.push(que[0].left) unless que[0].left.nil?
      que.push(que[0].right) unless que[0].right.nil?
      que.delete_at(0)
    end
    output
  end

  # returns array with tree elements (level order) recursively (input should be array with target node)
  def level_order_rec(que = [@root], output = [])
    return output if que.empty?

    output.push(que[0].data)
    que.push(que[0].left) unless que[0].left.nil?
    que.push(que[0].right) unless que[0].right.nil?
    que.delete_at(0)
    level_order_rec(que, output)
  end

  # returns array with tree elements (inorder)
  def inorder(node = @root, output = [])
    return if node.nil?

    inorder(node.left, output)
    output.push(node.data)
    inorder(node.right, output)
    output
  end

  # returns array with tree elements (preorder)
  def preorder(node = @root, output = [])
    return if node.nil?

    output.push(node.data)
    preorder(node.left, output)
    preorder(node.right, output)
    output
  end

  # returns array with tree elements (postorder)
  def postorder(node = @root, output = [])
    return if node.nil?

    postorder(node.left, output)
    postorder(node.right, output)
    output.push(node.data)
    output
  end

  # returns height of given node
  def height(node = @root)
    output = 0
    current_node = node
    until current_node.left.nil? && current_node.right.nil?
      output += 1
      if current_node.left.nil?
        current_node = current_node.right
      else
        current_node = current_node.left
      end
    end
    output
  end

  # returns depth of given node
  def depth(node, current_node = @root, output = 0)
    return output if current_node == node
    return nil if current_node.left.nil? && current_node.right.nil?
    output += 1
    if current_node > node
      depth(node, current_node.left, output)
    else
      depth(node, current_node.right, output)
    end
  end

  # returns true if the tree is balanced
  def balanced?(node = @root)
    return true if node.left.nil? && node.right.nil?

    if !node.left.nil? && !node.right.nil?
      return false if (height(node.left) - height(node.right)) > 1
      return false unless balanced?(node.left)
      return false unless balanced?(node.right)
    elsif node.left.nil?
      return false unless node.right.left.nil? && node.right.right.nil?
    elsif node.right.nil?
      return false unless node.left.left.nil? && node.left.right.nil?
    end
    true
  end

  # balances given node tree and assigns tree to object
  def rebalance(node = @root)
    tree_arr = level_order_itr(node)
    tree_arr = tree_arr.uniq.sort
    @root = build_tree(tree_arr)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
