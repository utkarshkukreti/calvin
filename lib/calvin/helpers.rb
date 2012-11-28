module Calvin
  module Helpers
    def ast(input)
      AST.new.parse(input)
    end

    def ast1(input)
      ast(input).first
    end

    def eval1(input)
      e = Evaluator.new
      e.evaluate(input)[0]
    end

    def preparse(input)
      PreParser.new.parse input
    end
  end
end
