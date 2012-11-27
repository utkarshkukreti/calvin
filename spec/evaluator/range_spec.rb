describe Calvin::Evaluator do
  describe "ranges" do
    it "should parse valid ranges" do
      eval1("..10").should eq 0..9
      eval1("1..100").should eq 1..100
      eval1("_10..10").should eq -10..10
    end

    it "should parse reverse ranges" do
      eval1("5.._5").should eq 5..-5
      eval1(".._5").should eq 0..-6
    end

    it "should parse stepped ranges" do
      eval1("1.4..9").should eq [1, 4, 7]
      eval1("1.4..7").should eq [1, 4, 7]
      eval1("1.4..6").should eq [1, 4]
      eval1("_1.3..6").should eq [-1, 3]
      eval1("_1.3..7").should eq [-1, 3, 7]
      eval1("_1._3.._7").should eq [-1, -3, -5, -7]
    end

    it "should not parse invalid ranges" do
      # Q: Should this raise error or return empty array?
      eval1("_1.6.._5").should eq []
    end

    it "should treat ranges as arrays when required" do
      eval1("1..4 + 5 6 7 8 - 2..5").should eq [4, 5, 6, 7]
      eval1("..100 - ..100").should eq [0] * 100
      eval1("10.._10 - 20..0").should eq [-10] * 21
    end

    it "should apply adverbs to ranges" do
      eval1("+\\1..10").should eq 55
      eval1("+\\1.4..9").should eq 12
      eval1("+\\_5._4..10").should eq 40

      # Large tests; to make sure performance is linear.
      # Specs won't terminate if it takes too long :)
      n = 1_000_000_000
      eval1("+\\1..#{n}").should eq (n * (n + 1) / 2)
      eval1("+\\_#{n}..#{n}").should eq 0
      eval1("+\\_#{n}..#{n+1}").should eq n + 1

      step = 4
      eval1("+\\1.#{step + 1}..#{n}").should eq eval1("+\\1..#{n}") / 4 - (n / 4) - (n / 8)
    end

    it "should return `.inspect` of `.to_a` on `.inspect`" do
      eval1("1._4.._10").inspect.should eq [1, -4, -9].inspect
    end
  end
end
