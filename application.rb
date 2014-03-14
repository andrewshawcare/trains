require_relative './weighted_directed_graph'

class Application
    def initialize(graph_file_path)
        edges = File.read(graph_file_path)
            .split(/,\s/)
            .map { |edge_string|
                {
                    tail: edge_string[0],
                    head: edge_string[1],
                    cost: edge_string[2].to_i
                }
            }
        @graph = WeightedDirectedGraph.new(edges)
    end

    def distance route
        index_of_last_intermediate_stop = route.length - 2
        route[0..index_of_last_intermediate_stop]
            .each_with_index
                .reduce(0) do |distance, (stop, index)|
                    neighbours = @graph.neighbours(stop)
                    next_stop = route[index + 1]
                    if (neighbours.has_key? next_stop)
                        distance + @graph.neighbours(stop)[next_stop]
                    else
                        return "NO SUCH ROUTE"
                    end
                end
    end

    def find_all_trips (parameters)
        @graph.search(parameters)
    end

    def find_trip (parameters)
        @graph.search(parameters.merge(first: true))
    end
end
