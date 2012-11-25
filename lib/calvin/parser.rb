module Calvin
  class Parser < Parslet::Parser
    rule(:space) { str(" ") }
    rule(:spaces?) { space.repeat }
    rule(:spaces) { space.repeat(1) }
    rule(:digit) { match["0-9"] }
    rule(:integer) { digit.repeat(1).as(:integer) }

    rule(:array) { (integer >> (space >> integer).repeat).as(:array) }

    {mapper: Core::Mappers, folder: Core::Folders, binary_operator: Core::BinaryOperators }.each do |type, hash|
      rule type do
        hash.keys.map { |key| str(key).as(type) }.reduce(:|)
      end
    end

    rule :monad do
      (integer >> binary_operator.as(:right) |
        binary_operator.as(:left) >> integer).as(:monad)
    end

    rule(:folded) { (binary_operator >> folder >> array).as(:folded) }
    rule(:mapped) { (monad >> mapper >> array).as(:mapped) }

    rule(:statement) { mapped | folded | array }
    rule(:statements) { statement.repeat }

    root(:statements)
  end
end