module Calvin
  class Parser < Parslet::Parser
    Verbs = []

    def self.verb(options)
      Verbs << options
    end

    rule(:spaces) { str(" ").repeat(1) }
    rule(:spaces?) { spaces.maybe }
    rule(:digit) { match["0-9"] }

    rule(:integer) { digit.repeat(1).as(:integer) }
    rule(:float) { (digit.repeat(1) >> str(".") >> digit.repeat(1)).as(:float) }

    rule(:atom) { (float | integer).as(:atom) }

    rule(:list) { (atom >> (spaces >> atom).repeat(1)).as(:list) }

    rule(:table) { (str("[") >> list >> (str(",") >> spaces? >> list).repeat >>
                    str("]")).as(:table) }

    # Rank: 0 = atom, 1 = list, 2 = table, ...
    #                L, M, R
    verb symbol: :+, ranks: [0, 0, 0]

    # dyad form
    rule :dyad do
      Verbs.map do |verb|
        left  = [atom, list, table][verb[:ranks][0]]
        right = [atom, list, table][verb[:ranks][2]]

        left.as(:left) >> spaces? >> str(verb[:symbol]).as(:symbol) >>
          spaces? >> right.as(:right)
      end.reduce(:|).as(:dyad)
    end

    # monad form
    rule :monad do
      Verbs.map do |verb|
        expression = [atom, list, table][verb[:ranks][1]]

        str(verb[:symbol]).as(:symbol) >> spaces? >> expression.as(:expression)
      end.reduce(:|).as(:monad)
    end

    rule(:sentence) { spaces? >> (dyad | monad | table | list | atom).as(:sentence) >> spaces? }

    rule(:sentences) { sentence.repeat }

    root(:sentences)
  end
end
