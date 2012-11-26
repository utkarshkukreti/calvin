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
          Evaluator::Helpers.apply lambda { |x| -x }, expression
        when :*
          Evaluator::Helpers.apply lambda { |x| x <=> 0 },expression
        when :/
          Evaluator::Helpers.apply lambda { |x| 1 / x },expression
        when :^
          Evaluator::Helpers.apply lambda { |x| Math::E ** x },expression
        when :%
          Evaluator::Helpers.apply lambda { |x| x.abs },expression
        end
      end

      rule dyad: subtree(:dyad) do
        left = dyad[:left]
        right = dyad[:right]
        symbol = dyad[:symbol].to_sym

        case symbol
        when :+
          if left.is_a?(Numeric)
            Evaluator::Helpers.apply lambda { |x| x + left }, right
          elsif right.is_a?(Numeric)
            # left must be array; TODO: add assertion
            Evaluator::Helpers.apply lambda { |x| x + right }, left
          else
            # both must be arrays; TODO: add assertion
          end

        when :-
          if left.is_a?(Numeric)
            Evaluator::Helpers.apply lambda { |x| left - x }, right
          elsif right.is_a?(Numeric)
            # left must be array; TODO: add assertion
            Evaluator::Helpers.apply lambda { |x| x - right }, left
          else
            # both must be arrays; TODO: add assertion
          end

        when :*
          if left.is_a?(Numeric)
            Evaluator::Helpers.apply lambda { |x| left * x }, right
          elsif right.is_a?(Numeric)
            # left must be array; TODO: add assertion
            Evaluator::Helpers.apply lambda { |x| x * right }, left
          else
            # both must be arrays; TODO: add assertion
          end

        when :/
          if left.is_a?(Numeric)
            Evaluator::Helpers.apply lambda { |x| left / x }, right
          elsif right.is_a?(Numeric)
            # left must be array; TODO: add assertion
            Evaluator::Helpers.apply lambda { |x| x / right }, left
          else
            # both must be arrays; TODO: add assertion
          end

        when :^
          if left.is_a?(Numeric)
            Evaluator::Helpers.apply lambda { |x| left ** x }, right
          elsif right.is_a?(Numeric)
            # left must be array; TODO: add assertion
            Evaluator::Helpers.apply lambda { |x| x ** right }, left
          else
            # both must be arrays; TODO: add assertion
          end

        when :%
          if left.is_a?(Numeric)
            Evaluator::Helpers.apply lambda { |x| left % x }, right
          elsif right.is_a?(Numeric)
            # left must be array; TODO: add assertion
            Evaluator::Helpers.apply lambda { |x| x % right }, left
          else
            # both must be arrays; TODO: add assertion
          end
        end
      end
    end

    # helpers
    module Helpers
      extend self

      def apply(fn, object)
        if object.is_a?(Array)
          object.map { |el| apply(fn, el) }
        else
          fn.call object
        end
      end
    end
  end
end
