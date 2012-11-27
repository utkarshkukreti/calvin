module Calvin
  class AST
    class Range
      include Enumerable

      attr_reader :first, :last, :step, :size

      def initialize(*numbers)
        if numbers.size == 2
          @first, @last = numbers
          @step = @first < @last ? 1 : -1
          @size = 1 + (@last - @first).abs
        elsif numbers.size == 3
          @first, second, @last = numbers
          @step = second - @first
          @size = 1 + (@last - @first) / @step
          @last = @first + @step * (@size - 1)
        else
          raise Core::ImpossibleException.new "Only 2 or 3 parameters are allowed. You passed in #{numbers.size}."
        end
      end

      def each
        @first.step(@last, @step) do |i|
          yield i
        end
      end

      def ==(other)
        case other
        when AST::Range
          first == other.first && step == other.step &&
            last == other.last
        when ::Range
          (step == 1 || step == -1) && first == other.first &&
            last == other.last
        when Array
          to_a == other
        else
          false
        end
      end

      def inspect
        to_a.inspect
      end
    end
  end
end
