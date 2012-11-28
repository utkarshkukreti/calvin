require "spec_helper"

describe Calvin::PreParser do
  it "should fill in missing parentheses" do
    preparse("8 + 9)").should eq "(8 + 9)"
    preparse("8) + (((9)").should eq "(8) + (((9)))"
    preparse("7+6)+(*..5").should eq "(7+6)+(*..5)"
  end
end
