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
  end
end
