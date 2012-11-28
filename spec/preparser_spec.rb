require "spec_helper"

describe Calvin::PreParser do
  it "should fill in missing parentheses" do
    preparse("8 + 9)").should eq "(8 + 9)"
    preparse("8) + (((9)").should eq "(8) + (((9)))"
    preparse("7+6)+(*..5").should eq "(7+6)+(*..5)"
  end

  it "should preparse assignment statements properly" do
    preparse("a = 10 + 7)))^2").should eq ("a = (((10 + 7)))^2")
    preparse("a = 10 + 7)^2").should eq ("a = (10 + 7)^2")
    preparse("a  =  10 + 7)^2").should eq ("a = (10 + 7)^2")
  end
end
