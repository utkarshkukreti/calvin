module Calvin
  class Core
    ImpossibleException = Exception.new

    BinaryOperators = { add: "+", multiply: "*", subtract: "-", divide: "/", power: "^", modulo: "%" }.invert
    Folders = { foldr: "\\:", foldl: "\\" }.invert
    Mappers = { map: "@" }.invert
  end
end
