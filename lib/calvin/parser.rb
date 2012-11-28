module Calvin
  class Parser < Parslet::Parser
    attr_reader :verbs, :adverbs, :verb, :adverb

    def initialize
      self.verbs = %w{+ - * / ^ % & <: >: = <> <= < >= > # | &}
      self.adverbs = %w{\\}
    end

    def verbs=(verbs)
      @verbs = verbs
      @verb = verbs.map { |verb| str(verb) }.reduce(:|).as(:verb)
    end

    def adverbs=(adverbs)
      @adverbs = adverbs
      @adverb = adverbs.map { |adverb| str(adverb) }.reduce(:|).as(:adverb)
    end

    # s = spaces; s? = spaces?
    rule(:s)       { str(" ").repeat(1) }
    rule(:s?)      { s.maybe }
    rule(:digit)   { match["0-9"] }
    rule(:digits)  { digit.repeat(1) }

    rule(:integer) { (str("_").maybe >> digits).as(:integer) }
    rule(:float)   { (str("_").maybe >> digits >> str(".") >> digits).as(:float) }
    rule(:range) do
      (
        (integer.as(:first) >> ((str(".") >> integer.as(:second)).maybe)).maybe >>
          str("..") >> integer.as(:last)
      ).as(:range)
    end

    rule(:atom)  { (range | float | integer | deassignment).as(:atom) }
    rule(:list)  { (atom >> (s >> atom).repeat(1)).as(:list) }
    rule(:table) { (str("[") >> list >> (str(",") >> s? >> list).repeat >>
                    str("]")).as(:table) }

    rule(:identifier)   { match["a-z"].repeat(1).as(:identifier) }
    rule(:assignment)   { (identifier >> s? >> str("=") >> s? >>
                          word.as(:expression)).as(:assignment) }
    rule(:deassignment) { identifier.as(:deassignment) }

    rule(:noun)         { (table | list | atom).as(:noun) }

    # dyad form
    rule :dyad do
      ((pword | noun).as(:left) >> s? >> (function | verb) >> s? >> word.as(:right)).as(:dyad)
    end

    # monad form
    rule :monad do
      ((function | lambda) >> s? >> word.as(:expression)).as(:monad)
    end

    rule :lambda do
      (verb >> adverb.maybe).repeat(1).as(:lambda)
    end

    # TODO: Choose a better name
    rule :function do
      (str("{") >> word.as(:lambda) >> str("}") >> s? >> str("|").as(:filter).maybe).as(:function)
    end

    rule(:word) { dyad | monad | function | lambda | table | list | atom | (pword >> word.maybe).as(:parentheses) }
    rule(:pword) { str("(") >> s? >> word >> s? >> str(")") >> s? }
    rule(:sentence) { s? >> (assignment | word.as(:sentence)) >> s? }

    rule(:sentences) { sentence.repeat }

    root(:sentences)
  end
end
