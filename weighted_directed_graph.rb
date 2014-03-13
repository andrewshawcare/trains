class WeightedDirectedGraph
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
end