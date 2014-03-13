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
end