describe Calvin::Evaluator do
  describe "adverbs" do
    it "should apply adverbs to single element" do
      # behaviour here is wonky
      eval1("+\\1").should eq 1
      eval1("=\\0").should eq 1
      eval1("=\\1").should eq 0
    end

    it "should apply adverbs to simple lists" do
      # Note: default is foldr, not foldl
      eval1("+\\1 2 3").should eq 6
      eval1("-\\1 2 3").should eq 2
      eval1("<\\1 2 3").should eq 1
      eval1("<=\\1 2 3").should eq 1
      eval1(">\\1 2 3").should eq 0
      eval1(">=\\1 2 3").should eq 0
      eval1("=\\1 1 1").should eq 1
      eval1("=\\1 2 1").should eq 0

      eval1("&\\4 5 6").should eq 4
      eval1("&\\1 0 0").should eq 0
      eval1("|\\2 3 2").should eq 3
      # FIXME: These don't work ->
      # eval1("&\\1 1 (3=2)").should eq 0
      # eval1("&\\1 1 (3=3)").should eq 1
      # eval1("|\\0 0 (3=3)").should eq 1
      # eval1("|\\(1=0) 0 (3=3)").should eq 1
      # eval1("|\\0 (3<>3) 0").should eq 1
    end
  end
end

