describe Calvin::Evaluator do
  describe "lambdas" do
    it "should parse statement with only one lambda" do
      eval1("+").should eq lambda: [{ verb: "+" }]
      eval1("-").should eq lambda: [{ verb: "-" }]
      eval1("*").should eq lambda: [{ verb: "*" }]
      eval1("/").should eq lambda: [{ verb: "/" }]
      eval1("^").should eq lambda: [{ verb: "^" }]
      eval1("%").should eq lambda: [{ verb: "%" }]
    end
  end
end
