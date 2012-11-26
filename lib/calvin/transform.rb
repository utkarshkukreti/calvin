module Calvin
  class Transform < Parslet::Transform
    rule(integer:  simple(:x))   { x.to_i }
    rule(float:    simple(:x))   { x.to_f }
    rule(atom:     simple(:x))   { x }
    rule(sentence: subtree(:x))  { x }
  end
end
