module Calvin
  class Evaluator < Parslet::Transform
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

      expression.map {|el| el.send(op, integer.to_i) }
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

      expression.map {|el| integer.to_i.send(op, el) }
    end

    rule expression: subtree(:expression) do
      expression
    end
  end
end
