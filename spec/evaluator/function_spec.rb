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

    it "should evaluate function followed by filter(`|`) as a filter operation" do
      eval1("{x=1}|2 3 1").should eq [1]
      eval1("{x=1}|1 2 3 1").should eq [1, 1]
      # http://projecteuler.net/problem=1
      eval1("+\\{((x%3)=0)|0=x%5}|..1000").should eq 233168
    end
  end
end
