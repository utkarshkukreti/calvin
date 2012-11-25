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

    rule(:folded) { (binary_operator >> folder >> array).as(:folded) }

    rule(:statement) { array | folded }
    rule(:statements) { statement.repeat }

    root(:statements)
  end
end
