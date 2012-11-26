module Calvin
  class AST
    def parse(input)
      Transform.new.apply Parser.new.parse(input)
    end
  end
end
