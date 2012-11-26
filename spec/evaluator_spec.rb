require "spec_helper"

describe Calvin::Evaluator do
  describe "should evaluate monads" do
    it "should evaluate negate (`-`) monad" do
      eval1("-1").should eq -1
      eval1("-0").should eq 0
      eval1("-1.1").should eq -1.1
      eval1("-0.0").should eq 0.0
      eval1("- 1 -3 5").should eq [-1, 3, -5]
      eval1("- [9 8, 7 -6 5]").should eq [[-9, -8], [-7, 6, -5]]
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

  describe "should evaluate dyads with one array" do
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

    it "should evaluate power(`^`) dyad" do
      eval1("3 ^ 2 4").should eq [9, 81]
      eval1("2 4 ^ 2").should eq [4, 16]
      eval1("-1 ^ 3 4").should eq [-1, 1]
      eval1("2 0.25 ^ -2.0").should eq [0.25, 16.0]
    end

    it "should evaluate modulo(`%`) dyad" do
      eval1("2 % 2 3").should eq [0, 2]
      eval1("2 5 % 2").should eq [0, 1]
      eval1("-1 % 2 4").should eq [1, 3]
      eval1("2 3 % -2").should eq [0, -1]
    end
  end

  describe "should evaluate dyads with 2 arrays" do
    it "should evaluate plus(`+`) dyad" do
      eval1("1 2 + 2 3").should eq [3, 5]
      eval1("2 3 + -2 -1").should eq [0, 2]
    end

    it "should evaluate minus(`-`) dyad" do
      eval1("1 1 - 2 3").should eq [-1, -2]
      eval1("2 3 - -2 -1").should eq [4, 4]
    end

    it "should evaluate multiply(`*`) dyad" do
      eval1("2 5 * 2 3").should eq [4, 15]
      eval1("2 3 * -2 -3").should eq [-4, -9]
    end

    it "should evaluate divide(`/`) dyad" do
      eval1("1.0 2.0 / 2 4").should eq [0.5, 0.5]
      eval1("2 4 / 2 1").should eq [1, 4]
    end

    it "should evaluate power(`^`) dyad" do
      eval1("3 3 ^ 2 4").should eq [9, 81]
      eval1("2.0 4.0 ^ -2 -1").should eq [0.25, 0.25]
    end

    it "should evaluate modulo(`%`) dyad" do
      eval1("2 6 % 2 3").should eq [0, 0]
      eval1("2 5 % 2 7").should eq [0, 5]
    end

    it "should not allow dyads on uneven array size" do
      expect { eval1("2 5 % 3 4 1") }.to raise_exception(ArgumentError)
      expect { eval1("[2 5, 2 1] % 3 4") }.to raise_exception(ArgumentError)
      expect { eval1("[2 5, 2 1] % [3 4, 1 2 3]") }.to raise_exception(ArgumentError)
    end
  end

  describe "chained verbs" do
    it "should parse chained monads/dyads" do
      eval1("1 + 2 + 3 4 + 4 5").should eq [10, 12]
      eval1("1 - 2 * 4 + 4 5").should eq [-15, -17]
      eval1("1 - 2 * 4 + 4 5").should eq [-15, -17]
      eval1("1 - 1 - 1 2 3 + 3 4 5 - 6 7 8").should eq [-2, -1, 0]
    end
  end

  describe "variables" do
    it "should store/retrieve variables" do
      e = Calvin::Evaluator.new

      e.apply ast("a =4")
      e.env["a"].should eq 4
      e.apply ast("b=8")
      e.env["b"].should eq 8
      e.apply ast("c= 16")
      e.env["c"].should eq 16
      e.apply ast("a=b c")
      e.env["a"].should eq [8, 16]
      e.apply ast("d =a+b c + a")
      e.env["d"].should eq [24, 48]
      e.apply ast("d = d d d")
      e.env["d"].should eq [[24, 48], [24, 48], [24, 48]]
    end
  end

  describe "brackets" do
    it "should respect precedence of brackets" do
      eval1("(2 ^ 2) + 1").should eq 5
      eval1("(1 2 + 2 3) * 2 2").should eq [6, 10]
      eval1("(2 2 * (2 2)) + 2 2").should eq [6, 6]
      eval1("(1 + 2 2 * (2 2)) + 2 2").should eq [7, 7]
    end
  end

  describe "ranges" do
    it "should parse valid ranges" do
      eval1("..10").should eq 0..9
      eval1("1..100").should eq 1..100
      eval1("-10..10").should eq -10..10
    end

    it "should parse reverse ranges" do
      eval1("5..-5").should eq 5..-5
    end

    it "should not parse invalid ranges" do
      expect { eval1("..-5") }.to raise_exception
    end

    it "should treat ranges as arrays when required" do
      eval1("1..4 + 5 6 7 8 - 2..5").should eq [4, 5, 6, 7]
      eval1("..100 - ..100").should eq [0] * 100
      eval1("10..-10 - 20..0").should eq [-10] * 21
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
