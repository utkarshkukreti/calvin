require "spec_helper"

describe Calvin do
  it "should have a VERSION" do
    Calvin::VERSION.should be_a String
  end
end
