module Calvin
  class Core
    ImpossibleException = Exception

    BinaryOperators = { add: "+", multiply: "*", subtract: "-", divide: "/", power: "^", modulo: "%" }.invert
    ComparisonOperators = { eq: "=", neq: "<>", lte: "<=", lt: "<", gte: ">=", gt: ">" }.invert
    Folders = { foldr: "\\:", foldl: "\\" }.invert
    Mappers = { map: "@" }.invert

    HistoryFile = File.expand_path("~/.calvin_history")
  end
end
