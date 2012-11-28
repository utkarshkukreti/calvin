require "spec_helper"

describe Calvin::Evaluator do
  describe "performance" do
    Zillion = 10**42
    # Basically, these tests won't terminate if things aren't optimized :)
    it "should optimize folding on ranges" do
      eval1("+\\1..#{Zillion}").should eq (Zillion * (Zillion + 1) / 2)
      eval1("+\\_#{Zillion}..#{Zillion}").should eq 0
      eval1("+\\_#{Zillion}..#{Zillion+1}").should eq Zillion + 1

      step = 4
      eval1("+\\1.#{step + 1}..#{Zillion}").should eq eval1("+\\1..#{Zillion}") / 4 - (Zillion / 4) - (Zillion / 8)
    end

    it "should optimize take on ranges" do
      eval1("10>:..#{Zillion}").should eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      eval1("4>:_100..#{Zillion}").should eq [-100, -99, -98, -97]
    end
  end
end
