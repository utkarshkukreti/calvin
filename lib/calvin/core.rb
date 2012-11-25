module Calvin
  class Core
    BinaryOperators = { add: "+", multiply: "*", subtract: "-", divide: "/", power: "^", modulo: "%" }.invert
    Folders = { foldl: "\\", foldr: "\\." }.invert
    Mappers = { map: "@" }.invert
  end
end
