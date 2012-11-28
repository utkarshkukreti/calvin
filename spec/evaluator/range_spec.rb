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

      eval1("*\\1..10").should eq 3628800
      eval1("*\\_1..10").should eq 0
      eval1("*\\_10.._1").should eq 3628800
      eval1("*\\_10.._2").should eq -3628800

      eval1("-\\1..100").should eq -50
      eval1("-\\_10..40").should eq 15
      eval1("-\\_10..39").should eq -25
      eval1("-\\_10..38").should eq 14
    end

    it "should multiply ranges with integers" do
      eval1("2 * ..5").should eq [0, 2, 4, 6, 8]
      eval1("2 * _2..2").should eq [-4, -2, 0, 2, 4]
      eval1("..5 * 2").should eq [0, 2, 4, 6, 8]
      eval1("_2..2 * 2").should eq [-4, -2, 0, 2, 4]
    end

    it "should return `.inspect` of `.to_a` on `.inspect`" do
      eval1("1._4.._10").inspect.should eq [1, -4, -9].inspect
    end
  end
end
