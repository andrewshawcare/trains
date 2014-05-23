require 'set'

class WeightedDirectedGraph

  @@uniform_cost_search_strategy = Proc.new do |fringe|
    fringe.reduce do |path, next_path|
      if path.last[:cost] < next_path.last[:cost]
        path
      else
        next_path
      end
    end
  end

  def initialize edges
    @adjacency_list = edges.reduce({}) do |adjacency_list, edge|
      adjacency_list[edge[:tail]] ||= {}
      adjacency_list[edge[:tail]][edge[:head]] = edge[:cost]
      adjacency_list
    end
  end

  def neighbours node
    @adjacency_list[node]
  end

  def search parameters
    strategy = parameters[:strategy] || @@uniform_cost_search_strategy
    root = parameters[:root] || raise("root is a required parameter for search")
    select = parameters[:select] || raise("select is a required parameter for search")
    reject = parameters[:reject]
    first = parameters[:first]
    fringe = [
      [
        {
          :value => root,
          :cost => 0
        }
      ]
    ]
    paths = []
    expanded_nodes = Set.new()

    until fringe.empty?
      path = strategy.call(fringe)
      fringe.delete_at(fringe.index(path))

      if (select.call(path))
        if first
          return path
        else
          paths.push(path)
        end
      end

      if reject or not expanded_nodes.member?(path.last[:value])
        neighbours = self.neighbours(path.last[:value])
        neighbours.each do |value, cost|
          fringe.unshift(
            path.dup.push(
              :value => value,
              :cost => path.last[:cost] + cost
            )
          )
        end
        expanded_nodes.add(path.last[:value])
      end

      if reject
        fringe.reject!(&reject)
      end
    end

    paths
  end
end
