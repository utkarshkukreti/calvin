module Calvin
  class PreParser
    def parse(input)
      # TODO: Change this when we add strings in the language

      # Check if it's an assignment
      assignment = input.match(/\s*(?<identifier>[a-zA-Z]+)\s*=\s*(?<expression>.*)$/)
      if assignment
        input = assignment["expression"]
      end

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

      if assignment
        output.insert 0, "#{assignment["identifier"]} = "
      end

      output
    end
  end
end
