require "bundler/setup"
require "calvin"

RSpec.configure do |config|
  def ast(input)
    Calvin::AST.new(input).ast
  end
end
