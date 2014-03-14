require_relative '../trains.rb'

describe Trains, "#output" do
    before(:each) do
        @application = Trains.new("./input.txt")
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
        @application.find_all_trips(
            :root => "C",
            :reject => Proc.new do |trip|
                trip.length > 4
            end,
            :select => Proc.new do |trip|
                trip.last[:value] == "C" and
                trip.length > 1 and
                trip.length <= 4
            end
        ).length.should eq(2)
    end

    it "returns 3 for the number of trips starting at A and ending at C with exactly 4 stops" do
        @application.find_all_trips(
            :root => "A",
            :reject => Proc.new do |trip|
                trip.length > 5
            end,
            :select => Proc.new do |trip|
                trip.last[:value] == "C" and
                trip.length > 1 and
                trip.length == 5
            end
        ).length.should eq(3)
    end

    it "returns 9 for the length of the shortest route (in terms of distance to travel) from A to C" do
        @application.find_trip(
            :root => "A",
            :select => Proc.new do |trip|
                trip.last[:value] == "C"
            end
        ).last[:cost].should eq(9)
    end
    
    it "returns 9 for the length of the shortest route (in terms of distance to travel) from B to B" do
        @application.find_trip(
            :root => "B",
            :select => Proc.new do |trip|
                trip.last[:value] == "B" and
                trip.length > 1
            end
        ).last[:cost].should eq(9)
    end

    it "returns 7 for the number of different routes from C to C with a distance of less than 30" do
        @application.find_all_trips(
            :root => "C",
            :reject => Proc.new do |trip|
                trip.last[:cost] >= 30
            end,
            :select => Proc.new do |trip|
                trip.last[:value] == "C" and
                trip.length > 1
            end
        ).length.should eq(7)
    end
end