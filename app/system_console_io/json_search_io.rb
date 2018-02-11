class SystemConsoleIO
  class JsonSearchIO
    FILE_SPLIT_REGEX = /\s?,\s?/.freeze

    ## Commands
    EXIT_COMMAND = '[[exit]]'.freeze
    HELP_COMMAND = '[[help]]'.freeze
    FILE_COMMAND = '[[file]]'.freeze

    ## UI printable content
    TITLE = 'Welcome to JsonSearch!'.bold.freeze
    INTRODUCTION = "Enter \"#{EXIT_COMMAND}\" to exit, "\
                   "\"#{FILE_COMMAND}\" to specify a file, or "\
                   "\"#{HELP_COMMAND}\" for a detailed list of commands.".freeze
    WELCOME_MESSAGE = "#{TITLE}\n#{INTRODUCTION}".freeze
    GOODBYE = "\nGoodbye!".bold.freeze
    SEARCH = "\nSearch:".bold.cyan.freeze
    AVAILABLE_FILES = "\nAvailable files (use commas to separate):".freeze
    HELP_COMMANDS = "#{'Command  | Action'.bold}\n"\
                    "#{EXIT_COMMAND.gray} | #{'Exits the application'.gray}\n"\
                    "#{HELP_COMMAND.gray} | #{'Shows the help'.gray}\n"\
                    "#{FILE_COMMAND.gray} | #{'Searches in specified files'.gray}\n".freeze

    def initialize
      @json_searchers = get_json_searchers
      @loop = true
      reset_file_selection
    end

    def start
      greeting
      console_search
      goodbye
    end

    private

    def console_search
      search_selection while @loop
    end

    def search_selection
      puts SEARCH
      @query = STDIN.gets.chomp

      case @query
      when EXIT_COMMAND
        @loop = false
      when HELP_COMMAND
        show_help
      when FILE_COMMAND
        file_search
      else
        system 'clear'
        process_search
      end
    end

    def file_search
      system 'clear'
      puts "#{AVAILABLE_FILES}\n  #{available_files}".bold
      @file_selection = STDIN.gets.chomp.split(FILE_SPLIT_REGEX)
    end

    def search(json_searchers:)
      json_searchers.inject({}) do |results, (key, json_searcher)|
        found, result = json_searcher.find(query: @query)
        results[key] = result if found

        results
      end
    end

    def process_search
      results = search(json_searchers: select_json_searchers)

      handle_results(results: results)

      reset_file_selection
    end

    def select_json_searchers
      return @json_searchers if @file_selection.empty?

      @json_searchers.select{ |key,value| @file_selection.include?(key) }
    end

    def handle_results(results:)
      if results.empty?
        puts "No results for: \"#{@query}\"".bold.red
      else
        results.each do |key, result|
          puts "\n\"#{@query}\", found in: \"#{key}\"".bold.green
          ap result
        end
      end
    end

    def available_files
      @available_files ||= @json_searchers.keys.sort.join("\n  ").brown
    end

    def show_help
      system 'clear'
      puts HELP_COMMANDS
    end

    def greeting
      system 'clear'
      puts WELCOME_MESSAGE
    end

    def goodbye
      puts GOODBYE
    end

    def reset_file_selection
      @file_selection = []
    end

    def get_json_searchers
      Dir[File.expand_path(File.join(ROOT_PATH, 'resources','*.json'))].inject({}) do |json_searchers, file_path|
        json_searcher = JsonSearcher.new(file_path: file_path) rescue nil
        json_searchers[json_searcher.name] = json_searcher if json_searcher
        json_searchers
      end
    end
  end
end
