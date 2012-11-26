describe Calvin::Evaluator do
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
end
