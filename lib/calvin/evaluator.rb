module Calvin
  class Evaluator < Parslet::Transform
    attr_accessor :env

    def initialize
      super
      @env = {}

      rule monad: subtree(:monad) do
        symbol = monad[:symbol].to_sym
        expression = monad[:expression]

        case symbol
        when :+
          # Just return expression, for now.
          expression
        when :-
          Evaluator::Helpers.negate expression
        when :*
          Evaluator::Helpers.sign expression
        when :/
          Evaluator::Helpers.reciprocal expression
        end
      end
    end

    # helpers
    module Helpers
      extend self

      def negate(object)
        if object.is_a?(Array)
          object.map(&method(:negate))
        else
          - object
        end
      end

      def sign(object)
        if object.is_a?(Array)
          object.map(&method(:sign))
        else
          object <=> 0
        end
      end

      def reciprocal(object)
        if object.is_a?(Array)
          object.map(&method(:reciprocal))
        else
          1 / object
        end
      end
    end
  end
end
