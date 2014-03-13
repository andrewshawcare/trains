require_relative '../application'

describe Application, "#output" do
    before(:each) do
        @application = Application.new("./input.txt")
    end

    it "returns 9 for the distance of route A-B-C" do
        @application.distance(["A", "B", "C"]).should eq(9)
    end

    it "returns 5 for the distance of route A-D" do
        @application.distance(["A", "D"]).should eq(5)
    end

    it "returns 13 for the distance of route A-D-C" do
        @application.distance(["A", "D", "C"]).should eq(13)
    end

    it "returns 22 for the distance of route A-E-B-C-D" do
        @application.distance(["A", "E", "B", "C", "D"]).should eq(22)
    end

    it "returns NO SUCH ROUTE for the distance of route A-E-D" do
        @application.distance(["A", "E", "D"]).should eq("NO SUCH ROUTE")
    end

    it "returns 2 for the number of trips starting at C and ending at C with a maximum of 3 stops" do
        @application.find_all_trips({
            start: "C",
            limit: Proc.new do |trip|
                trip.length > 3
            end,
            select: Proc.new do |trip|
                trip.last == "C" and
                trip.length <= 3
            end
        }).length.should eq(2)
    end

    it "returns 3 for the number of trips starting at A and ending at C with exactly 4 stops" do
        @application.find_all_trips({
            start: "C",
            limit: Proc.new do |trip|
                trip.length > 4
            end,
            select: Proc.new do |trip|
                trip.last == "C" and
                trip.length == 4
            end
        }).length.should eq(3)
    end

    it "returns 9 for the length of the shortest route (in terms of distance to travel) from A to C" do
        @application.find_trip({
            start: "A",
            select: Proc.new do |trip|
                trip.last == "C"
            end
        }).distance.should eq(9)
    end

    it "returns 9 for the length of the shortest route (in terms of distance to travel) from B to B" do
        @application.find_trip({
            start: "B",
            select: Proc.new do |trip|
                trip.last == "B"
            end
        }).distance.should eq(9)
    end

    it "returns 7 for the number of different routes from C to C with a distance of less than 30" do
        @application.find_all_trips({
            start: "C",
            limit: Proc.new do |path|
                path.cost >= 30
            end,
            select: Proc.new do |path|
                path.last.value == "C"
            end
        }).length.should eq(2)
    end
end