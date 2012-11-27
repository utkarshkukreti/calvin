describe Calvin::Evaluator do
  describe "should evaluate monads" do
    it "should evaluate negate (`-`) monad" do
      eval1("-1").should eq -1
      eval1("-0").should eq 0
      eval1("-1.1").should eq -1.1
      eval1("-0.0").should eq 0.0
      eval1("- 1 _3 5").should eq [-1, 3, -5]
      eval1("- [9 8, 7 _6 5]").should eq [[-9, -8], [-7, 6, -5]]
    end

    it "should evaluate sign (`*`) monad" do
      eval1("*1").should eq 1
      eval1("*0").should eq 0
      eval1("*1.1").should eq 1
      eval1("*0.0").should eq 0
      eval1("* 1 _3 5").should eq [1, -1, 1]
      eval1("*[9 8, 7 _6 0]").should eq [[1, 1], [1, -1, 0]]
    end

    it "should evaluate reciprocal (`/`) monad" do
      eval1("*1.1").should eq 1
      eval1("*0.0").should eq 0
      eval1("* _1 _2 _4").should eq [-1, -1, -1]
      eval1("*[9 8, 7 _6 0]").should eq [[1, 1], [1, -1, 0]]
    end

    it "should evaluate exponential (`^`) monad" do
      def e(num); Math::E ** num; end
      eval1("^3").should eq e(3)
      eval1("^1.1").should eq e(1.1)
      eval1("^0").should eq e(0)
      eval1("^ _1 2 _4").should eq [e(-1), e(2), e(-4)]
      eval1("^[9 8, 7 _6 0]").should eq [[e(9), e(8)], [e(7), e(-6), e(0)]]
    end

    it "should evaluate magnitude/absolute (`%`) monad" do
      eval1("%1.1").should eq 1.1
      eval1("%0").should eq 0
      eval1("%_1.1").should eq 1.1
      eval1("% _1 _2 4").should eq [1, 2, 4]
      eval1("%[9 8, 7 _6 0]").should eq [[9, 8], [7, 6, 0]]
    end

    it "should evaluate count (`#`) monad" do
      eval1("#1").should eq 1
      eval1("# 1 2 3").should eq 3
      eval1("# [1 2, 3 4 5]").should eq 2
    end
  end
end
