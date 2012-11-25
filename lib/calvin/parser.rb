module Calvin
  class Parser < Parslet::Parser
    rule(:space) { str(" ") }
    rule(:spaces?) { space.repeat }
    rule(:spaces) { space.repeat(1) }
    rule(:digit) { match["0-9"] }

    rule(:integer) { digit.repeat(1).as(:integer) }
    rule(:constant) { integer }
    rule(:identifier) { match["a-z"].repeat(1).as(:identifier) }
    rule(:deassignment) { identifier.as(:deassignment) }
    rule(:variable) { constant }

    rule(:array) { (variable >> (space >> variable).repeat).as(:array) }

    rule(:range) { (integer.as(:first).maybe >> str("..") >> integer.as(:last)).as(:range) }
    {mapper: Core::Mappers, folder: Core::Folders, binary_operator: Core::BinaryOperators }.each do |type, hash|
      rule type do
        hash.keys.map { |key| str(key).as(type) }.reduce(:|)
      end
    end

    rule :monad do
      (variable >> binary_operator.as(:right) |
        binary_operator.as(:left) >> variable).as(:monad)
    end

    rule(:folded) { (binary_operator >> folder >> expression).as(:folded) }
    rule(:mapped) { (monad >> mapper >> expression).as(:mapped) }

    rule(:assignment) { (identifier >> str(":=") >> expression).as(:assignment) }

    rule(:expression) { (deassignment | mapped | folded | range | array).as(:expression) }
    rule(:statement) { assignment | expression }
    rule(:statements) { statement.repeat }

    root(:statements)
  end
end
