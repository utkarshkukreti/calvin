module Calvin
  class AST
    class Range
      include Enumerable

      attr_accessor :first, :second, :last

      def initialize(*numbers)
        if numbers.size == 2
          @first, @last = numbers
        elsif numbers.size == 3
          @first, @second, @last = numbers
        else
          raise Core::ImpossibleException.new "Only 2 or 3 parameters are allowed. You passed in #{numbers.size}."
        end
      end

      def each
        if @second.nil?
          method = @first > @last ? :downto : :upto
          @first.send(method, @last) do |i|
            yield i
          end
        else
          @first.step(@last, @second - @first) do |i|
            yield i
          end
        end
      end

      def size
        1 + ((last - first) / step).abs
      end

      def step
        second ? second - first : (first > last ? -1 : 1)
      end

      def ==(other)
        if @second.nil?
          other.respond_to?(:first) && other.first == @first &&
          other.respond_to?(:last) && other.last == @last
        else
          case other
          when Array
            to_a == other
          when AST::Range
            other.first == first && other.step == step &&
              other.last == last
          else
            false
          end
        end
      end

      def inspect
        to_a.inspect
      end
    end
  end
end
