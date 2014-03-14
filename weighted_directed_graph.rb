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
        root, select, reject, strategy = parameters.values_at(:root, :select, :reject, :strategy)
        reject ||= Proc.new {|trip| false}
        strategy ||= @@uniform_cost_search_strategy
        expanded_nodes = Set.new []
        fringe = [
            [{value: root, cost: 0}]
        ]
        paths = []
        
        until fringe.empty?
            path = strategy.call(fringe)
            fringe.delete_at(fringe.index(path))

            if (select.call(path))
                paths.push(path)
            end
            
            #unless expanded_nodes.include? path.last[:value]
                #expanded_nodes.add path.last[:value]
            self.neighbours(path.last[:value]).each {|value, cost|
                fringe.unshift(
                    path.dup.push({
                        value: value,
                        cost: path.last[:cost] + cost
                    })
                )
            }
            #end
            fringe.reject!(&reject)
        end

        return paths
    end
end