module Calvin
  class Transform < Parslet::Transform
    rule(integer:     simple(:x))  { x.to_i }
    rule(float:       simple(:x))  { x.to_f }
    rule(atom:        subtree(:x)) { x }
    rule(list:        subtree(:x)) { x }
    rule(table:       subtree(:x)) { x }
    rule(noun:        subtree(:x)) { x }
    rule(sentence:    subtree(:x)) { x }
    rule(parentheses: subtree(:x)) { x }
  end
end
