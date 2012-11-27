module Calvin
  class Parser < Parslet::Parser
    Verbs = []
    Adverbs = []

    def self.verb(verb, options = {})
      Verbs << options.merge(verb: verb)
    end

    def self.adverb(adverb, options = {})
      Adverbs << options.merge(adverb: adverb)
    end

    rule(:spaces) { str(" ").repeat(1) }
    rule(:spaces?) { spaces.maybe }
    rule(:digit) { match["0-9"] }

    rule(:integer) { (str("_").maybe >> digit.repeat(1)).as(:integer) }
    rule(:float) { (str("_").maybe >> digit.repeat(1) >> str(".") >>
                    digit.repeat(1)).as(:float) }
    rule(:range) { ((integer.maybe.as(:first)) >> str("..") >>
                    integer.as(:last)).as(:range) }

    rule(:atom) { (range | float | integer | deassignment).as(:atom) }

    rule(:list) { (atom >> (spaces >> atom).repeat(1)).as(:list) }

    rule(:table) { (str("[") >> list >> (str(",") >> spaces? >> list).repeat >>
                    str("]")).as(:table) }

    rule(:identifier) { match["a-z"].repeat(1).as(:identifier) }
    rule(:assignment) { (identifier >> spaces? >> str("=") >> spaces? >>
                         word.as(:expression)).as(:assignment) }
    rule(:deassignment) { identifier.as(:deassignment) }

    rule(:noun) { (table | list | atom).as(:noun) }

    # Rank: 0 = atom, 1 = list, 2 = table, ...
    #                        L, M, R
    verb :+, ranks: [0, 0, 0]
    verb :-, ranks: [0, 0, 0], space: true
    verb :*, ranks: [0, 0, 0]
    verb :/, ranks: [0, 0, 0]
    verb :^, ranks: [0, 0, 0]
    verb :%, ranks: [0, 0, 0]

    verb "="
    verb "<>"
    verb :<=
    verb :<
    verb :>=
    verb :>

    verb "#"

    adverb "\\"

    # dyad form
    rule :dyad do
      verbs = Verbs.map { |verb| str verb[:verb] }.reduce(:|).as(:verb)
      ((pword | noun).as(:left) >> spaces? >> verbs >> spaces? >> word.as(:right)).as(:dyad)
    end

    # monad form
    rule :monad do
      adverbs = Adverbs.map { |adverb| str adverb[:adverb] }.reduce(:|).as(:adverb)
      verbs = Verbs.map { |verb| str verb[:verb] }.reduce(:|).as(:verb)
      ((verbs >> spaces? >> adverbs.maybe) >> spaces? >> word.as(:expression)).as(:monad)
    end

    rule(:word) { dyad | monad | table | list | atom | (pword >> word.maybe).as(:parentheses) }
    rule(:pword) { str("(") >> spaces? >> word >> spaces? >> str(")") >> spaces? }
    rule(:sentence) { spaces? >> (assignment | word.as(:sentence)) >> spaces? }

    rule(:sentences) { sentence.repeat }

    root(:sentences)
  end
end
