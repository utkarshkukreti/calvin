require "bundler/setup"
require "calvin"

RSpec.configure do |config|
  def ast(input)
    Calvin::AST.new(input).ast
  end

  def aste(input)
    ast(input)[0][:expression]
  end

  def eval(input)
    Calvin::Evaluator.new.apply ast(input)
  end

  def eval1(input)
    eval(input).first
  end
end
