class SystemConsoleIO
  class JsonSearchIO
    def initialize
      @json_searchers = get_json_searchers
    end

    def start
      greeting

      while true
        puts "\nSearch:".bold.cyan
        @query = gets.chomp

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

      goodbye
    end

    private

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
        puts 'No results'.bold.red
      else
        results.each do |key, result|
          puts "\n Found in: \"#{key}\"".bold.green
          ap result
        end
      end
    end

    def show_help
      system 'clear'
      puts 'TODO add help commands'
    end

    def greeting
      system 'clear'
      puts "Welcome to JsonSearch!".bold
      puts "Enter [[exit]] to exit, or [[help]] for a full list of commands."
    end

    def goodbye
      puts "\nGoodbye!".bold
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
