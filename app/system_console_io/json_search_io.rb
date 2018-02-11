class SystemConsoleIO
  class JsonSearchIO
    TITLE = 'Welcome to JsonSearch!'.bold.freeze
    INTRODUCTION = 'Enter "[[exit]]" to exit, or "[[help]]" for a full list of commands.'.freeze
    WELCOME_MESSAGE = "#{TITLE}\n#{INTRODUCTION}".freeze
    GOODBYE = "\nGoodbye!".bold.freeze
    SEARCH = "\nSearch:".bold.cyan.freeze
    NO_RESULTS = 'No results'.bold.red.freeze
    HELP_COMMANDS = "#{'Command  | Action'.bold}\n"\
                    "#{'[[exit]]'.gray} | #{'Exits the application'.gray}\n" \
                    "#{'[[help]]'.gray} | #{'Shows the help'.gray}\n".freeze

    def initialize
      @json_searchers = get_json_searchers
    end

    def start
      greeting
      console_search
      goodbye
    end

    private

    def console_search
      while true
        puts SEARCH
        @query = STDIN.gets.chomp

        case @query
        when '[[exit]]'
          break
        when '[[help]]'
          show_help
        else
          system 'clear'
          process_search
        end
      end
    end

    def search
      @json_searchers.inject({}) do |results, (key, json_searcher)|
        found, result = json_searcher.find(query: @query)
        results[key] = result if found

        results
      end
    end

    def process_search
      results = search

      if results.empty?
        puts NO_RESULTS
      else
        results.each do |key, result|
          puts "\n Found in: \"#{key}\"".bold.green
          ap result
        end
      end
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

    def get_json_searchers
      Dir[File.expand_path(File.join(ROOT_PATH, 'resources','*.json'))].inject({}) do |json_searchers, file_path|
        json_searcher = JsonSearcher.new(file_path: file_path) rescue nil
        json_searchers[json_searcher.name] = json_searcher if json_searcher
        json_searchers
      end
    end
  end
end
