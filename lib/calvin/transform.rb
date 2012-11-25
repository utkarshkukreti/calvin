module Calvin
  class Transform < Parslet::Transform
    rule(integer:  simple(:x))   { x.to_i }
    rule(array:    sequence(:x)) { x }
    rule(array:    simple(:x))   { [x] }
    rule(function: simple(:x))   { x.to_s }
    rule(applier:  simple(:x))   { x.to_s }
  end
end
