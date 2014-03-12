require_relative '../application'

describe Application, "#output" do
  it "returns 9 for the distance of route A-B-C" do
    application = Application.new "graph.txt"
    application.distance(["A", "B", "C"]).should eq(9)
  end
end