module Calvin
  class PreParser
    def parse(input)
      # TODO: Change this when we add strings in the language
      # Simple stack based parentheses balancer
      stack = []
      output = ""
      input.chars.each do |char|
        if char == ")"
          if stack.empty?
            output.insert(0, "(")
          else
            stack.pop
          end
          output << ")"
        elsif char == "("
          stack.push "("
          output << "("
        else
          output << char
        end
      end

      stack.each do
        output << ")"
      end

      output
    end
  end
end
