module Calvin
  class Parser < Parslet::Parser
    Verbs = []
    Adverbs = []

    def self.verb(options)
      Verbs << options
    end

    def self.adverb(options)
      Adverbs << options
    end

    rule(:spaces) { str(" ").repeat(1) }
    rule(:spaces?) { spaces.maybe }
    rule(:digit) { match["0-9"] }

    rule(:integer) { (str("-").maybe >> digit.repeat(1)).as(:integer) }
    rule(:float) { (str("-").maybe >> digit.repeat(1) >> str(".") >>
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
    verb symbol: :+, ranks: [0, 0, 0]
    verb symbol: :-, ranks: [0, 0, 0], space: true
    verb symbol: :*, ranks: [0, 0, 0]
    verb symbol: :/, ranks: [0, 0, 0]
    verb symbol: :^, ranks: [0, 0, 0]
    verb symbol: :%, ranks: [0, 0, 0]

    verb symbol: "="
    verb symbol: "<>"
    verb symbol: :<=
    verb symbol: :<
    verb symbol: :>=
    verb symbol: :>

    verb symbol: "#"

    adverb symbol: "\\"

    # dyad form
    rule :dyad do
      Verbs.map do |verb|
        (pword | noun).as(:left) >> spaces? >> str(verb[:symbol]).as(:symbol) >>
          (verb[:space] ? spaces : spaces?) >> word.as(:right)
      end.reduce(:|).as(:dyad)
    end

    # monad form
    rule :monad do
      adverbs = Adverbs.map{ |adverb| str adverb[:symbol] }.reduce(:|).as(:adverb)
      Verbs.map do |verb|
        str(verb[:symbol]).as(:symbol) >>
          ((adverbs >> spaces?) | (verb[:space] ? spaces : spaces?)) >>
          word.as(:expression)
      end.reduce(:|).as(:monad)
    end

    rule(:word) { dyad | monad | table | list | atom | (pword >> word.maybe).as(:parentheses) }
    rule(:pword) { str("(") >> spaces? >> word >> spaces? >> str(")") >> spaces? }
    rule(:sentence) { spaces? >> (assignment | word.as(:sentence)) >> spaces? }

    rule(:sentences) { sentence.repeat }

    root(:sentences)
  end
end
