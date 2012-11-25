module Calvin
  class Transform < Parslet::Transform
    rule(integer: simple(:x)) { x.to_i }
    rule(array: simple(:x)) { x }
  end
end
