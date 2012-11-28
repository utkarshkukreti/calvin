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

    rule(:spaces) { str(" ").repeat(1) }
    rule(:spaces?) { spaces.maybe }
    rule(:digit) { match["0-9"] }

    rule(:integer) { (str("_").maybe >> digit.repeat(1)).as(:integer) }
    rule(:float) { (str("_").maybe >> digit.repeat(1) >> str(".") >>
                    digit.repeat(1)).as(:float) }
    rule(:range) do
      (
        (integer.as(:first) >> ((str(".") >> integer.as(:second)).maybe)).maybe >>
          str("..") >> integer.as(:last)
      ).as(:range)
    end

    rule(:atom) { (range | float | integer | deassignment).as(:atom) }

    rule(:list) { (atom >> (spaces >> atom).repeat(1)).as(:list) }

    rule(:table) { (str("[") >> list >> (str(",") >> spaces? >> list).repeat >>
                    str("]")).as(:table) }

    rule(:identifier) { match["a-z"].repeat(1).as(:identifier) }
    rule(:assignment) { (identifier >> spaces? >> str("=") >> spaces? >>
                         word.as(:expression)).as(:assignment) }
    rule(:deassignment) { identifier.as(:deassignment) }

    rule(:noun) { (table | list | atom).as(:noun) }

    # dyad form
    rule :dyad do
      ((pword | noun).as(:left) >> spaces? >> (function | verb) >> spaces? >> word.as(:right)).as(:dyad)
    end

    # monad form
    rule :monad do
      ((function | lambda) >> spaces? >> word.as(:expression)).as(:monad)
    end

    rule :lambda do
      (verb >> adverb.maybe).repeat(1).as(:lambda)
    end

    # TODO: Choose a better name
    rule :function do
      (str("{") >> word.as(:lambda) >> str("}") >> spaces? >> str("|").as(:filter).maybe).as(:function)
    end

    rule(:word) { dyad | monad | function | lambda | table | list | atom | (pword >> word.maybe).as(:parentheses) }
    rule(:pword) { str("(") >> spaces? >> word >> spaces? >> str(")") >> spaces? }
    rule(:sentence) { spaces? >> (assignment | word.as(:sentence)) >> spaces? }

    rule(:sentences) { sentence.repeat }

    root(:sentences)
  end
end
