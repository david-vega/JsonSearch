# SystemConsoleIO::JsonSearchIO class represents a
# console input/output to search on json files
class SystemConsoleIO
  class JsonSearchIO
    ## Regex
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

    # Initializes the search engine for the given json file
    # @json_searchers: [Hash[JsonSearcher] Collection of JsonSearcher objects
    # @loop: [Boolean] Keeps the console running until the [[exit]] command is given
    # @file_selection: [Array] Selector of files to search
    def initialize
      @json_searchers = get_json_searchers
      @loop = true
      reset_file_selection
    end

    # Starts the console and waits for the user input
    # Prints in the console messages to drive the application
    def start
      greeting
      console_search
      goodbye
    end

    private

    # Loops the console
    def console_search
      search_selection while @loop
    end

    # Drives the input/output on the console
    def search_selection
      puts SEARCH
      @query = STDIN.gets.chomp

      case @query
      when EXIT_COMMAND
        @loop = false
      when HELP_COMMAND
        show_help
      when FILE_COMMAND
        specify_files_to_search
      else
        system 'clear'
        process_search
      end
    end

    # Displays the available files to search and
    # receives and stores the user's input list of files
    def specify_files_to_search
      system 'clear'
      puts "#{AVAILABLE_FILES}\n  #{@json_searchers.keys.join("\n  ").brown}".bold
      @file_selection = STDIN.gets.chomp.split(FILE_SPLIT_REGEX)
    end

    # Searches in the given JsonSearchers
    # == Params:
    # - json_searchers: [Hash] Contains all the JsonSearch objects to execute the search
    # ==Result
    # - [Hash] Search results
    def search(json_searchers:)
      json_searchers.inject({}) do |results, (key, json_searcher)|
        found, result = json_searcher.find(query: @query)
        results[key] = result if found

        results
      end
    end

    # Execute the search
    def process_search
      results = search(json_searchers: select_json_searchers)

      handle_results(results: results)

      reset_file_selection
    end

    # Selects the JsonSearch if a file selection exist
    def select_json_searchers
      return @json_searchers if @file_selection.empty?

      @json_searchers.select{ |key,value| @file_selection.include?(key) }
    end

    # Prints the search results
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

    # Prints a list of available commands with description
    def show_help
      system 'clear'
      puts HELP_COMMANDS
    end

    # Prints a welcome message with instructions
    def greeting
      system 'clear'
      puts WELCOME_MESSAGE
    end

    # Prints a goodbye message
    def goodbye
      puts GOODBYE
    end

    # Clears the @file_selection
    def reset_file_selection
      @file_selection = []
    end

    # Loads and creates a JsonSearcher model for each file in 'resources' folder
    def get_json_searchers
      Dir[File.expand_path(File.join(ROOT_PATH, 'resources','*.json'))].inject({}) do |json_searchers, file_path|
        json_searcher = JsonSearcher.new(file_path: file_path) rescue nil
        json_searchers[json_searcher.name] = json_searcher if json_searcher
        json_searchers
      end
    end
  end
end
