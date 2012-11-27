describe Calvin::Evaluator do
  describe "functions" do
    it "should parse bare functions" do
      eval1("{+\\-\\}").should be_a(Hash)
    end

    it "should eval function as a monad" do
      eval1("{x^2+x}3 1 4").should eq [3 ** 5, 1 ** 3, 4 ** 6]
      eval1("{x-x+x}3").should eq -3
    end

    it "should eval function as a dyad" do
      eval1("1 2 3{x+y}3 1 4").should eq [4, 3, 7]
      eval1("1{x-y}3 1 3").should eq [-2, 0, -2]
    end

    it "should eval mixture of monad/dyad functions" do
      eval1("1 2 3{x-y}2{x^y}2 3 4").should eq [-3, -6, -13]
    end
  end
end
