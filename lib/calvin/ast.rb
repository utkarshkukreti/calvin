module Calvin
  class AST
    attr_reader :ast

    def initialize(input)
      @ast = Transform.new.apply Parser.new.parse(input)
    end
  end
end
