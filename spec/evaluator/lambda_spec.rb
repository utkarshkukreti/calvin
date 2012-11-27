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

    it "should parse statement with lambdas with multiple verbs/adverbs" do
      eval1("++\\").should eq lambda: [{ verb: "+" }, { verb: "+", adverb: "\\"} ]
      eval1("+\\+-\\").should eq lambda: [{ verb: "+", adverb: "\\" }, { verb: "+" },
                                        { verb: "-", adverb: "\\"} ]
    end
  end
end
