module Calvin
  class Evaluator < Parslet::Transform
    attr_accessor :env

    def initialize
      super
      @env = {}

      rule assignment: { identifier: simple(:name), expression:
        subtree(:expression)} do |context|
        @env[context[:name].to_s] = context[:expression]
      end

      rule deassignment: { identifier: simple(:name) } do |context|
        @env[context[:name].to_s]
      end

      rule range: subtree(:range) do
        if range[:first]
          range[:first]..range[:last]
        else
          0..(range[:last] - 1)
        end
      end

      rule folded: { binary_operator: simple(:op), folder: simple(:folder),
        expression: subtree(:expression) } do
        if folder == "\\"
        elsif folder == "\\:"
          expression.reverse!
        else
          raise Core::ImpossibleException
        end

        case op.to_sym
        when :+, :-, :%, :*, :/
          expression.reduce op.to_sym
        when :^
          expression.reduce :**
        else
          raise Core::ImpossibleException
        end
      end

      rule mapped: { monad: { left: { binary_operator: simple(:op) },
        integer: simple(:integer) }, mapper: simple(:mapper), expression: subtree(:expression) } do
        if mapper == "@"
        else
          raise Core::ImpossibleException
        end

        op = op().to_sym # hack; make it a var
        if op == :^
          op = :**
        end

        if expression.is_a?(Array)
          expression.map {|el| el.send(op, integer.to_i) }
        else
          expression.send(op, integer.to_i)
        end
      end

      rule mapped: { monad: { right: { binary_operator: simple(:op) },
        integer: simple(:integer) }, mapper: simple(:mapper), expression: subtree(:expression) } do
        if mapper == "@"
        else
          raise Core::ImpossibleException
        end

        op = op().to_sym # hack; make it a var
        if op == :^
          op = :**
        end

        if expression.is_a?(Array)
          expression.map {|el| integer.to_i.send(op, el) }
        else
          integer.to_i.send(op, expression)
        end
      end

      rule expression: subtree(:expression) do
        expression
      end
    end
  end
end
