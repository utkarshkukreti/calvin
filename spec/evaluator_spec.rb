require "spec_helper"

describe Calvin::Evaluator do
  describe "should evaluate monads" do
    it "should evaluate negate (`-`) monad" do
      eval1("-1").should eq -1
      eval1("-0").should eq 0
      eval1("-1.1").should eq -1.1
      eval1("-0.0").should eq 0.0
      eval1("- 1 -3 5").should eq [-1, 3, -5]
      eval1("-[9 8, 7 -6 5]").should eq [[-9, -8], [-7, 6, -5]]
    end

    it "should evaluate sign (`*`) monad" do
      eval1("*1").should eq 1
      eval1("*0").should eq 0
      eval1("*1.1").should eq 1
      eval1("*0.0").should eq 0
      eval1("* 1 -3 5").should eq [1, -1, 1]
      eval1("*[9 8, 7 -6 0]").should eq [[1, 1], [1, -1, 0]]
    end

    it "should evaluate reciprocal (`/`) monad" do
      eval1("*1.1").should eq 1
      eval1("*0.0").should eq 0
      eval1("* -1 -2 -4").should eq [-1, -1, -1]
      eval1("*[9 8, 7 -6 0]").should eq [[1, 1], [1, -1, 0]]
    end

    it "should evaluate exponential (`^`) monad" do
      def e(num); Math::E ** num; end
      eval1("^3").should eq e(3)
      eval1("^1.1").should eq e(1.1)
      eval1("^0").should eq e(0)
      eval1("^ -1 2 -4").should eq [e(-1), e(2), e(-4)]
      eval1("^[9 8, 7 -6 0]").should eq [[e(9), e(8)], [e(7), e(-6), e(0)]]
    end

    it "should evaluate magnitude/absolute (`%`) monad" do
      eval1("%1.1").should eq 1.1
      eval1("%0").should eq 0
      eval1("%-1.1").should eq 1.1
      eval1("% -1 -2 4").should eq [1, 2, 4]
      eval1("%[9 8, 7 -6 0]").should eq [[9, 8], [7, 6, 0]]
    end
  end

  describe "should evaluate dyads" do
    it "should evaluate plus(`+`) dyad" do
      eval1("1 + 2 3").should eq [3, 4]
      eval1("2 3 + 2").should eq [4, 5]
      eval1("-1 + 2 3").should eq [1, 2]
      eval1("2 3 + -2").should eq [0, 1]
    end

    it "should evaluate minus(`-`) dyad" do
      eval1("1 - 2 3").should eq [-1, -2]
      eval1("2 3 - 2").should eq [0, 1]
      eval1("-1 - 2 3").should eq [-3, -4]
      eval1("2 3 - -2").should eq [4, 5]
    end

    it "should evaluate multiply(`*`) dyad" do
      eval1("1 * 2 3").should eq [2, 3]
      eval1("2 3 * 2").should eq [4, 6]
      eval1("-1 * 2 3").should eq [-2, -3]
      eval1("2 3 * -2").should eq [-4, -6]
    end

    it "should evaluate divide(`/`) dyad" do
      eval1("1.0 / 2 4").should eq [0.5, 0.25]
      eval1("2 4 / 2").should eq [1, 2]
      eval1("-1.0 / 2 4").should eq [-0.5, -0.25]
      eval1("2 3 / -1").should eq [-2, -3]
    end
  end
#   it "should parse foldl" do
#     eval1("+\\1 2 3").should eq 6
#     eval1("-\\1 2 3").should eq -4
#     eval1("*\\2 3 5").should eq 30
#     eval1("/\\8 2 2").should eq 2
#     eval1("%\\9 7 9").should eq 2
#     eval1("^\\2 2 3").should eq 64
#   end
#
#   it "should parse foldr" do
#     eval1("+\\:1 2 3").should eq 6
#     eval1("-\\:1 2 3").should eq 0
#     eval1("*\\:2 3 5").should eq 30
#     eval1("/\\:2 2 8").should eq 2
#     eval1("%\\:9 7 9").should eq 2
#     eval1("^\\:2 2 3").should eq 81
#   end
#
#   it "should parse map" do
#     eval1("+2@1 2 3").should eq [3, 4, 5]
#     eval1("2+@1 2 3").should eq [3, 4, 5]
#
#     eval1("-2@1 2 3").should eq [-1, 0, 1]
#     eval1("2-@1 2 3").should eq [1, 0, -1]
#
#     eval1("*2@1 2 3").should eq [2, 4, 6]
#     eval1("2*@1 2 3").should eq [2, 4, 6]
#
#     eval1("/2@9 6 3").should eq [4, 3, 1]
#     eval1("4/@1 2 3").should eq [4, 2, 1]
#
#     eval1("%2@1 2 3").should eq [1, 0, 1]
#     eval1("2%@1 2 3").should eq [0, 0, 2]
#
#     eval1("^2@1 2 3").should eq [1, 4, 9]
#     eval1("2^@1 2 3").should eq [2, 4, 8]
#   end
#
#   it "should parse filter" do
#     eval1(">3@1 2 4").should eq [4]
#     eval1("<3@1 6 1").should eq [1, 1]
#     eval1(">=3@1 3 4").should eq [3, 4]
#     eval1("<=3@1 3 4").should eq [1, 3]
#     eval1("=3@1 2 3 3 4").should eq [3, 3]
#
#     eval1("3>@1 2 4").should eq [1, 2]
#     eval1("3<@1 6 1").should eq [6]
#     eval1("3>=@1 3 4").should eq [1, 3]
#     eval1("3<=@1 3 4").should eq [3, 4]
#     eval1("3=@1 2 3 3 4").should eq [3, 3]
#   end
#
#   it "should parse nested expressions" do
#     eval1("+\\2^@1 2 3").should eq 14
#     eval1("-\\:-2@1 2 3").should eq 2
#     eval1("/2@^2@2+@1 2 3").should eq [4, 8, 12]
#   end
#
#   it "should parse ranges" do
#     eval1("..10").should eq 0..9
#     eval1("1..100").should eq 1..100
#     eval1("+\\1..100").should eq (100 * 101) / 2
#     eval1("+\\..100").should eq (99 * 100) / 2
#   end
#
#   it "should map ranges" do
#     eval1("^2@1..3").should eq [1, 4, 9]
#     eval1("2^@1..3").should eq [2, 4, 8]
#   end
#
#   it "should apply monads to single element too" do
#     eval1("*2@+\\1 2 3").should eq 12
#   end
#
#   it "should save assigned variables in env" do
#     e = Calvin::Evaluator.new
#
#     e.apply ast("a:=1")
#     e.env["a"].should eq [1]
#     e.apply(ast("a")[0]).should eq [1]
#
#     e.apply ast("a:=1 2 4")
#     e.apply(ast("a")[0]).should eq [1, 2, 4]
#
#     e.apply ast("b:=+\\4..6")
#     e.apply(ast("b")[0]).should eq 15
#   end
end
