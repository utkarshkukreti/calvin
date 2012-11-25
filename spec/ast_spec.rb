require "spec_helper"

# describe Calvin::AST do
#   describe "Array" do
#     it "should parse simple arrays" do
#       aste("1").should eq [1]
#       aste("1 2 3").should eq [1, 2, 3]
#     end
#   end
#
#   describe "Folder" do
#     it "should parse folding with binary operators on arrays" do
#       aste("+\\1 2 3").should eq folded: { binary_operator: "+", folder: "\\", array: [1, 2, 3] }
#       aste("-\\1 2 3").should eq folded: { binary_operator: "-", folder: "\\", array: [1, 2, 3] }
#       aste("*\\1 2 3").should eq folded: { binary_operator: "*", folder: "\\", array: [1, 2, 3] }
#       aste("/\\1 2 3").should eq folded: { binary_operator: "/", folder: "\\", array: [1, 2, 3] }
#       aste("^\\1 2 3").should eq folded: { binary_operator: "^", folder: "\\", array: [1, 2, 3] }
#       aste("%\\1 2 3").should eq folded: { binary_operator: "%", folder: "\\", array: [1, 2, 3] }
#     end
#   end
# end
