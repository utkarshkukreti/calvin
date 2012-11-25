module Calvin
  class CLI
    def initialize(argv)
      # ignore argv, for now
      repl
    end

    def repl
      require 'readline'

      puts "Calvin Programming Language REPL."
      puts "Type exit or press Ctrl-D to exit."
      lines = ""
      loop do
        prompt = "> "
        line = Readline::readline(prompt)

        exit if line.nil? || line == "exit"

        Readline::HISTORY.push line

        begin
          ast = AST.new(line).ast
          p Evaluator.new.apply(ast)[0]
        rescue Exception => e
          puts e
          p e.message
          puts e.backtrace
        end
      end
    end
  end
end
