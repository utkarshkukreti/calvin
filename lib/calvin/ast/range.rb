module Calvin
  class AST
    class Range
      include Enumerable

      attr_accessor :first, :last

      def initialize(first, last)
        @first = first
        @last = last
      end

      def each
        method = @first > @last ? :downto : :upto
        @first.send(method, @last) do |i|
          yield i
        end
      end

      def size
        1 + (@first - @last).abs
      end

      def ==(other)
        other.respond_to?(:first) && other.first == @first &&
        other.respond_to?(:last) && other.last == @last
      end
    end
  end
end
