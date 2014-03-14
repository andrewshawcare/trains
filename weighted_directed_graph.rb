class WeightedDirectedGraph
    @@uniform_cost_search_strategy = Proc.new do |fringe|
        fringe.reduce {|path, next_path|
            path.last[:cost] < next_path.last[:cost] ? path : next_path
        }
    end

    def initialize(edges)
        @adjacency_list = edges.reduce({}) do |adjacency_list, edge|
            unless adjacency_list.has_key? edge[:tail]
                adjacency_list[edge[:tail]] = {}
            end
            adjacency_list[edge[:tail]][edge[:head]] = edge[:cost]
            adjacency_list
        end
    end

    def neighbours node
        @adjacency_list[node]
    end

    def search parameters
        parameters[:strategy] ||= @@uniform_cost_search_strategy
        fringe = [[{value: parameters[:root], cost: 0}]]
        paths = []
        expanded_nodes = Set.new()

        until fringe.empty?
            path = parameters[:strategy].call(fringe)
            fringe.delete_at(fringe.index(path))

            if (parameters[:select].call(path))
                if parameters.has_key?(:first)
                    return path
                else
                    paths.push(path)
                end
            end

            if parameters.has_key?(:reject) or not expanded_nodes.member? path.last[:value]
                self.neighbours(path.last[:value]).each {|value, cost|
                    fringe.unshift(
                        path.dup.push({
                            value: value,
                            cost: path.last[:cost] + cost
                        })
                    )
                }
                expanded_nodes.add path.last[:value]
            end

            if parameters.has_key?(:reject)
                fringe.reject!(&parameters[:reject])
            end
        end

        return paths
    end
    
end