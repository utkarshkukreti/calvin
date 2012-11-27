module Calvin
  class Evaluator < Parslet::Transform
    attr_accessor :env

    def initialize
      super
      @env = {}

      rule assignment: { identifier: simple(:identifier),
                         expression: subtree(:expression) } do |context|
        @env[context[:identifier].to_s] = context[:expression]
      end

      rule deassignment: { identifier: simple(:identifier) } do |context|
        @env[context[:identifier].to_s]
      end

      rule range: { last: simple(:last) } do
        AST::Range.new 0, last - 1
      end

      rule range: { first: simple(:first), last: simple(:last) } do
        AST::Range.new first, last
      end

      rule range: { first: simple(:first), second: simple(:second), last: simple(:last) } do
        AST::Range.new first, second, last
      end

      rule monad: { lambda: subtree(:lambda), expression: subtree(:expression) } do |context|
        function = context[:lambda]
        expression = context[:expression]

        function.reverse_each.reduce(expression) do |fold, function|
          apply monad: function.merge(expression: fold)
        end
      end

      rule monad: { verb: simple(:_verb), adverb: simple(:adverb),
                    expression: subtree(:expression) } do
          verb = _verb.to_sym
          case adverb
          when "\\"
            case verb
            when :+, :-, :*, :/, :%
              Evaluator::Helpers.foldr verb, expression
            when :^
              Evaluator::Helpers.foldr :**, expression
            when :"="
              Evaluator::Helpers.foldr :"==", expression
            when :"<>"
              Evaluator::Helpers.foldr :"!=", expression
            when :<, :<=, :>, :>=
              Evaluator::Helpers.foldr verb, expression
            end
          else
            raise Core::ImpossibleException.new "Invalid adverb in monad #{monad.inspect}."
          end
      end

      rule monad: { verb: simple(:_verb), expression: subtree(:expression) } do
        verb = _verb.to_sym
        case verb
        when :+, :"=", :"<>", :<, :<=, :>, :>=
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
        when :"#"
          # count doesn't apply atomically. It always returns a single integer.
          if expression.is_a?(Numeric)
            1
          elsif expression.respond_to?(:size)
            expression.size
          else
            raise ArgumentError.new "Cannot calculate size of `expression` #{expression.inspect}"
          end
        end
      end

      rule dyad: subtree(:dyad) do
        left = dyad[:left]
        right = dyad[:right]
        verb = dyad[:verb].to_sym

        case verb
        when :+, :-, :*, :/, :%
          Evaluator::Helpers.apply_dyad verb, left, right
        when :^
          Evaluator::Helpers.apply_dyad :**, left, right
        when :"="
          Evaluator::Helpers.apply_dyad :"==", left, right
        when :"<>"
          Evaluator::Helpers.apply_dyad :"!=", left, right
        when :<, :<=, :>, :>=
          Evaluator::Helpers.apply_dyad verb, left, right
        end
      end
    end

    # helpers
    module Helpers
      extend self

      def apply(fn, object)
        if object.respond_to?(:map)
          object.map { |el| apply(fn, el) }
        else
          fn.call object
        end
      end

      def foldr(fn, object)
        comparison = %w{== <> > >= < <=}.include?(fn.to_s)
        if comparison
          if !object.respond_to?(:reduce)
            0.send(fn, object)
          else
            object.each_cons(2).reduce do |fold, (left, right)|
              fold && left.send(fn, right)
            end
          end
        elsif object.respond_to?(:reduce)
          object.reverse_each.reduce do |left, right|
            apply_dyad fn, right, left
          end
        else
          object
        end
      end

      def apply_dyad(fn, left, right)
        if fn.is_a?(Symbol)
          sym = fn
          fn = lambda { |left, right| left.send(sym, right) }
        end

        if left.is_a?(Numeric)
          Evaluator::Helpers.apply lambda { |x| fn.call(left,  x) }, right
        elsif right.is_a?(Numeric)
          Evaluator::Helpers.apply lambda { |x| fn.call(x, right) }, left
        else
          Evaluator::Helpers.apply_each fn, left, right
        end
      end

      def apply_each(fn, left, right)
        if left.respond_to?(:map) && right.respond_to?(:map)
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
        elsif left.is_a?(Numeric) && right.respond_to?(:map)
          right.map do |r|
            fn.call left, r
          end
        elsif right.is_a?(Numeric) && left.respond_to?(:map)
          left.map do |l|
            fn.call l, right
          end
        else
          # Raise error: Structure doesn't match
          raise ArgumentError.new "Structure doesn't match. `left`'s class is #{left.class}, while `right`'s is #{right.class}."
        end
      end
    end
  end
end
