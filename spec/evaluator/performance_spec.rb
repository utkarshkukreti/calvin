require "spec_helper"

describe Calvin::Evaluator do
  describe "performance" do
    # Basically, these tests won't terminate if things aren't optimized :)
    it "should optimize folding on ranges" do
      n = 1_000_000_000
      eval1("+\\1..#{n}").should eq (n * (n + 1) / 2)
      eval1("+\\_#{n}..#{n}").should eq 0
      eval1("+\\_#{n}..#{n+1}").should eq n + 1

      step = 4
      eval1("+\\1.#{step + 1}..#{n}").should eq eval1("+\\1..#{n}") / 4 - (n / 4) - (n / 8)
    end
  end
end
