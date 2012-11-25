require "spec_helper"

describe Calvin::Evaluator do
  it "should parse foldl" do
    eval("+\\1 2 3").should eq [6]
    eval("-\\1 2 3").should eq [-4]
    eval("*\\2 3 5").should eq [30]
    eval("/\\8 2 2").should eq [2]
    eval("%\\9 7 9").should eq [2]
    eval("^\\2 2 3").should eq [64]
  end

  it "should parse foldr" do
    eval("+\\.1 2 3").should eq [6]
    eval("-\\.1 2 3").should eq [0]
    eval("*\\.2 3 5").should eq [30]
    eval("/\\.2 2 8").should eq [2]
    eval("%\\.9 7 9").should eq [2]
    eval("^\\.2 2 3").should eq [81]
  end
end
