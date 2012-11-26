describe Calvin::Evaluator do
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
end
