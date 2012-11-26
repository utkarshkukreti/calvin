module Calvin
  class CLI
    def initialize(argv)
      if argv.any?
        puts "Argument passed: #{argv.inspect}"
      end
      @verbose = argv.include?("--verbose")
      repl
    end

    def repl
      evaluator = Evaluator.new
      require 'readline'

      puts "Calvin Programming Language REPL."
      puts "Type exit or press Ctrl-D to exit."
      lines = ""
      loop do
        prompt = "> "
        line = Readline::readline(prompt)

        if line.nil? || line == "exit"
          # Pressing Ctrl-D doesn't create a new line like <CR> after "exit"
          # So, print a new line!
          puts if line.nil?
          puts "Bye!"
          exit
        end

        Readline::HISTORY.push line

        begin
          next if line == ""

          ast = AST.new.parse(line)

          if @verbose
            puts  "      AST: #{ast.inspect}"
            print "Evaluated: "
          end

          p evaluator.apply(ast)[0]
        rescue Exception => e
          puts e
          p e.message
          puts e.backtrace
        end
      end
    end
  end
end
