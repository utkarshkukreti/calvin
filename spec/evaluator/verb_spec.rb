describe Calvin::Evaluator do
  describe "chained verbs" do
    it "should parse chained monads/dyads" do
      eval1("1 + 2 + 3 4 + 4 5").should eq [10, 12]
      eval1("1 - 2 * 4 + 4 5").should eq [-15, -17]
      eval1("1 - 2 * 4 + 4 5").should eq [-15, -17]
      eval1("1 - 1 - 1 2 3 + 3 4 5 - 6 7 8").should eq [-2, -1, 0]
    end
  end
end
