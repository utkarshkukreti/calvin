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
        when :^
          Evaluator::Helpers.exponential expression
        when :%
          Evaluator::Helpers.magnitude expression
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

      def exponential(object)
        if object.is_a?(Array)
          object.map(&method(:exponential))
        else
          Math::E ** object
        end
      end

      def magnitude(object)
        if object.is_a?(Array)
          object.map(&method(:magnitude))
        else
          object.abs
        end
      end
    end
  end
end
