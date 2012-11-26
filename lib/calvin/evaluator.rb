module Calvin
  class Evaluator < Parslet::Transform
    attr_accessor :env

    def initialize
      super
      @env = {}
    end
  end
end
