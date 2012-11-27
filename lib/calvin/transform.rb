module Calvin
  class Transform < Parslet::Transform
    rule(integer:     simple(:x))  { x.to_s.sub("_", "-").to_i }
    rule(float:       simple(:x))  { x.to_s.sub("_", "-").to_f }
    rule(atom:        subtree(:x)) { x }
    rule(list:        subtree(:x)) { x }
    rule(table:       subtree(:x)) { x }
    rule(noun:        subtree(:x)) { x }
    rule(sentence:    subtree(:x)) { x }
    rule(parentheses: subtree(:x)) { x }

    # Make some things lazy
    rule monad: { function: subtree(:function),
                  expression: subtree(:expression) } do
      { monad: { function: AST::Lazy.new(function), expression: expression } }
    end

    rule dyad: { left: subtree(:left), function: subtree(:function),
                 right: subtree(:right) } do
      { dyad: { left: left, function: AST::Lazy.new(function), right: right } }
    end
  end
end
