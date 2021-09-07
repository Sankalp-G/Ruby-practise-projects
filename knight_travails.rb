class Node
  include Comparable
  attr_accessor :coord, :connections

  def initialize(coord)
    @coord = coord
    @connections = []
  end
end

class KnightBoard
  attr_accessor :graph

  def initialize
    @graph = Array.new(8) { Array.new(8) { nil } }
    populate_graph
    interconnect_nodes
  end

  def valid_moves(start_coords)
    moves = [[1, 2], [-1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, 1], [-2, -1]]

    output = moves.map { |coord| [start_coords[0] + coord[0], start_coords[1] + coord[1]] }
    output.filter { |coords| coords[0].between?(0, 7) && coords[1].between?(0, 7) }
  end

  # creats an 8x8 grid of nodes
  def populate_graph(graph = @graph)
    graph.each_with_index do |row, row_index|
      row.each_with_index do |_tile, tile_index|
        graph[row_index][tile_index] = Node.new([row_index, tile_index])
      end
    end
    graph
  end

  # interconects the grid of nodes according to the way a knight moves
  def interconnect_nodes(graph = @graph)
    graph.each do |row|
      row.each do |tile|
        valid_moves(tile.coord).each do |move|
          move_node = graph[move[0]][move[1]]
          tile.connections.push(move_node)
        end
      end
    end
    graph
  end

  # finds path between two nodes by breadth first and using indexes to find parent
  def path(start_coord, end_coord)
    start_node = @graph[start_coord[0]][start_coord[1]]

    que = [[start_node, nil]]
    searched = []
    while true
      current_node = que[0][0]
      parent_index = que[0][1]

      searched << [current_node.coord, parent_index]

      break if current_node.coord == end_coord

      curr_index = searched.length - 1
      current_node.connections.each do |node|
        que << [node, curr_index]
      end
      que.delete_at(0)
    end
    process_path(searched)
  end

  # finds shortest path from last node in the array to the first
  def process_path(searched)
    result = []
    result_curr = searched[-1]
    until result_curr[1].nil?
      result << result_curr[0]
      result_curr = searched[result_curr[1]]
    end
    result << searched[0][0]
    result.reverse
  end

  def knight_moves(start_coord, end_coord)
    path = path(start_coord, end_coord)
    puts "You made it in #{path.length - 1} moves! Here's your path:"
    path.each { |coord| p coord }
  end
end

board = KnightBoard.new

board.knight_moves([3, 3], [7, 4])
