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
          Evaluator::Helpers.apply_dyad lambda { |left, right| left + right }, left, right
        when :-
          Evaluator::Helpers.apply_dyad lambda { |left, right| left - right }, left, right
        when :*
          Evaluator::Helpers.apply_dyad lambda { |left, right| left * right }, left, right
        when :/
          Evaluator::Helpers.apply_dyad lambda { |left, right| left / right }, left, right
        when :^
          Evaluator::Helpers.apply_dyad lambda { |left, right| left ** right }, left, right
        when :%
          Evaluator::Helpers.apply_dyad lambda { |left, right| left % right }, left, right
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

      def apply_dyad(fn, left, right)
        if left.is_a?(Numeric)
          Evaluator::Helpers.apply lambda { |x| fn.call(left,  x) }, right
        elsif right.is_a?(Numeric)
          Evaluator::Helpers.apply lambda { |x| fn.call(x, right) }, left
        else
          Evaluator::Helpers.apply_each fn, left, right
        end
      end

      def apply_each(fn, left, right)
        if left.is_a?(Array) && right.is_a?(Array)
          if left.size == right.size
            left.zip(right).map do |l, r|
              apply_each(fn, l, r)
            end
          else
            # Raise error: Size doesn't match
            raise ArgumentError.new "Array size doesn't match. `left` had size #{left.size}, while `right` had size #{right.size}."
          end
        elsif left.is_a?(Numeric) && right.is_a?(Numeric)
          fn.call(left, right)
        else
          # Raise error: Structure doesn't match
          raise ArgumentError.new "Structure doesn't match. `left`'s class is #{left.class}, while `right`'s is #{right.class}."
        end
      end
    end
  end
end
