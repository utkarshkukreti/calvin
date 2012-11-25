require "spec_helper"

describe Calvin::AST do
  describe "Array" do
    it "should parse simple arrays" do
      ast("1 2 3").should eq [array: [1, 2, 3]]
      ast("1 2 3 ").should eq [array: [1, 2, 3]]
      ast("1  2    3").should eq [array: [1, 2, 3]]
    end
  end
end
