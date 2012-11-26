module Calvin
  module Helpers
    def ast(input)
      AST.new.parse(input)
    end

    def ast1(input)
      ast(input).first
    end

    def eval1(input)
      ast = ast1(input)
      Evaluator.new.apply ast
    end
  end
end
