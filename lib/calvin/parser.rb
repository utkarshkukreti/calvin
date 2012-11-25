module Calvin
  class Parser < Parslet::Parser
    rule(:spaces) { match[" \t"].repeat(1) }
    rule(:spaces?) { spaces.maybe }
    rule(:digit) { match["0-9"] }
    rule(:integer) { digit.repeat(1).as(:integer) }

    rule(:array) { (integer >> (spaces >> integer).repeat >> spaces?).as(:array) }

    rule(:statement) { array }
    rule(:statements) { statement.repeat }

    root(:statements)
  end
end
