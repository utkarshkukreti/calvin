module Calvin
  module Helpers
    def ast(input)
      AST.new.parse(input)
    end

    def ast1(input)
      ast(input).first
    end
  end
end
