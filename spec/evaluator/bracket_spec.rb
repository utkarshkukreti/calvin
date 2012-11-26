describe Calvin::Evaluator do
  describe "brackets" do
    it "should respect precedence of brackets" do
      eval1("(2 ^ 2) + 1").should eq 5
      eval1("(1 2 + 2 3) * 2 2").should eq [6, 10]
      eval1("(2 2 * (2 2)) + 2 2").should eq [6, 6]
      eval1("(1 + 2 2 * (2 2)) + 2 2").should eq [7, 7]
    end
  end
end
