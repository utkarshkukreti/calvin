require "spec_helper"

describe Calvin::AST do
  describe "Atom" do
    it "should parse integers" do
      ast1("1").should eq 1
      ast1("2 ").should eq 2
      ast1(" 2 ").should eq 2
    end

    it "should parse floats" do
      ast1("1.99").should eq 1.99
      ast1("28.8 ").should eq 28.8
      ast1(" 2.9 ").should eq 2.9
    end
  end

  describe "List" do
    it "should parse lists" do
      ast1("1 2").should eq list: [1, 2]
      ast1("12 2.3").should eq list: [12, 2.3]
    end
  end
  
  describe "Table" do
    it "should parse tables" do
      ast1("[1 1, 2 2]").should eq table: [{list: [1, 1]}, {list: [2, 2]}]
    end
  end
end
