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

      # load history
      if File.exist?(Core::HistoryFile)
        log ">>> Loading History from #{Core::HistoryFile}..."
        `tail -256 #{Core::HistoryFile}`.split("\n").each do |line|
          Readline::HISTORY.push line
        end
        log ">>> Pushed #{Readline::HISTORY.size} lines into the buffer."
      end

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

        # write history
        File.open(Core::HistoryFile, "a") do |f|
          f.puts line
        end

        Readline::HISTORY.push line

        begin
          next if line == ""

          preparsed = PreParser.new.parse(line)
          ast = AST.new.parse(preparsed)

          log "Preparsed: #{preparsed}"
          log "      AST: #{ast.inspect}"
          log "Evaluated: "

          if @verbose
            start_time = Time.now
            ret = evaluator.apply(ast)[0]
            puts "Time taken: #{Time.now - start_time}s"
            p ret
          else
            p evaluator.apply(ast)[0]
          end
        rescue Exception => e
          puts e
          p e.message
          puts e.backtrace
        end
      end
    end

    private
    def log(line)
      puts line if @verbose
    end
  end
end
