module Calvin
  class AST
    class Lazy
      attr_reader :get
      def initialize(get)
        @get = get
      end
    end
  end
end
