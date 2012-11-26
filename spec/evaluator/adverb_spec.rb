describe Calvin::Evaluator do
  describe "adverbs" do
    it "should apply adverbs to single element" do
      # behaviour here is wonky
      eval1("+\\1").should eq 1
      eval1("=\\0").should eq true
      eval1("=\\1").should eq false
    end

    it "should apply adverbs to simple lists" do
      # Note: default is foldr, not foldl
      eval1("+\\1 2 3").should eq 6
      eval1("-\\1 2 3").should eq 2
      eval1("<\\1 2 3").should eq true
      eval1("<=\\1 2 3").should eq true
      eval1(">\\1 2 3").should eq false
      eval1(">=\\1 2 3").should eq false
      eval1("=\\1 1 1").should eq true
      eval1("=\\1 2 1").should eq false
    end
  end
end

