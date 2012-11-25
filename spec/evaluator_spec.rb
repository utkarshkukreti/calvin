require "spec_helper"

describe Calvin::Evaluator do
  it "should parse foldl" do
    eval1("+\\1 2 3").should eq 6
    eval1("-\\1 2 3").should eq -4
    eval1("*\\2 3 5").should eq 30
    eval1("/\\8 2 2").should eq 2
    eval1("%\\9 7 9").should eq 2
    eval1("^\\2 2 3").should eq 64
  end

  it "should parse foldr" do
    eval1("+\\.1 2 3").should eq 6
    eval1("-\\.1 2 3").should eq 0
    eval1("*\\.2 3 5").should eq 30
    eval1("/\\.2 2 8").should eq 2
    eval1("%\\.9 7 9").should eq 2
    eval1("^\\.2 2 3").should eq 81
  end

  it "should parse map" do
    eval1("+2@1 2 3").should eq [3, 4, 5]
    eval1("2+@1 2 3").should eq [3, 4, 5]

    eval1("-2@1 2 3").should eq [-1, 0, 1]
    eval1("2-@1 2 3").should eq [1, 0, -1]

    eval1("*2@1 2 3").should eq [2, 4, 6]
    eval1("2*@1 2 3").should eq [2, 4, 6]

    eval1("/2@9 6 3").should eq [4, 3, 1]
    eval1("4/@1 2 3").should eq [4, 2, 1]

    eval1("%2@1 2 3").should eq [1, 0, 1]
    eval1("2%@1 2 3").should eq [0, 0, 2]

    eval1("^2@1 2 3").should eq [1, 4, 9]
    eval1("2^@1 2 3").should eq [2, 4, 8]
  end
end
