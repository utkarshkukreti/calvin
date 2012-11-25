module Calvin
  class Evaluator < Parslet::Transform
    rule folded: { binary_operator: simple(:op), folder: simple(:folder), array: sequence(:array) } do
      if folder == "\\"
      elsif folder == "\\."
        array.reverse!
      else
        raise Core::ImpossibleException
      end

      case op.to_sym
      when :+, :-, :%, :*, :/
        array.reduce op.to_sym
      when :^
        array.reduce :**
      else
        raise Core::ImpossibleException
      end
    end

    rule mapped: { monad: { left: { binary_operator: simple(:op) },
      integer: simple(:integer) }, mapper: simple(:mapper), array: sequence(:array) } do
      if mapper == "@"
      else
        raise Core::ImpossibleException
      end

      op = op().to_sym # hack; make it a var
      if op == :^
        op = :**
      end

      array.map {|el| el.send(op, integer.to_i) }
    end

    rule mapped: { monad: { right: { binary_operator: simple(:op) },
      integer: simple(:integer) }, mapper: simple(:mapper), array: sequence(:array) } do
      if mapper == "@"
      else
        raise Core::ImpossibleException
      end

      op = op().to_sym # hack; make it a var
      if op == :^
        op = :**
      end

      array.map {|el| integer.to_i.send(op, el) }
    end
  end
end
