# JsonSearcher class represents search engine for a given Json file
class JsonSearcher
  attr_reader :data, :name

  ## Regex
  FILE_NAME_REGEX = /([^\/]+)(?=\.\w+$)/.freeze

  # Initializes the search engine for the given json file
  # @file_path: [String] Path to the json file
  # @name: [String] Name of the file
  # @data: [Array, Hash, String] Json on ruby format
  # == Params:
  # - file_path: [String] Accessible path to the json file
  def initialize(file_path:)
    @file_path = file_path
    @name = file_path[FILE_NAME_REGEX]
    @data = JSON.parse(File.read(@file_path))
  end

  # Searches in the Json file the given query and returns the result
  # == Params:
  # - query: [String] Text to search
  # == Result:
  # - [Array] 2 elements
  #   1.- [Boolean] Represents if there where results for the given query
  #   2.- [Array, Hash, other] Element(s) that matched the query
  def find(query:)
    @query = query

    search_by_class(data: @data)
  end

  private

  # Selects a type of search given the data
  # == Params:
  # - data: [Array, Hash, other] Object to execute the search
  # == Result:
  # - [Array] 2 elements
  #   1.- [Boolean] Represents if there where results for the given query
  #   2.- [Array, Hash, other] Element(s) that matched the query
  def search_by_class(data:)
    case data.class.to_s
    when 'Array'
      find_in_array(array: data)
    when 'Hash'
      find_in_hash(hash: data)
    else
      find_in_value(value: data)
    end
  end

  # Searches in an array
  # == Params:
  # - array: [Array] Object to execute the search
  # == Result:
  # - [Array] 2 elements
  #   1.- [Boolean] Represents if there where results for the given query
  #   2.- [Array] Collection of elements that matched the query
  def find_in_array(array:)
    result = array.inject([]) do |result, data|
               found, value = search_by_class(data: data)
               result << value if found
               result
             end

    # when result = [false], result.any? => false :(
    [!result.empty?, result]
  end

  # Searches in a hash
  # == Params:
  # - hash: [Hash] Object to execute the search
  # == Result:
  # - [Array] 2 elements
  #   1.- [Boolean] Represents if there where results for the given query
  #   2.- [Hash] Key value pair of elements that matched the query
  def find_in_hash(hash:)
    result = hash.inject({}) { |result, (key, value)| search_within_hash(result: result, key: key, value: value) }

    [result.any?, result]
  end

  # Searches in an object
  # Note: it will be treated as a String
  # == Params:
  # - value: [object] Object to execute the search
  # == Result:
  # - [Array] 2 elements
  #   1.- [Boolean] Represents if there where results for the given query
  #   2.- [object] Value that matched the query
  def find_in_value(value:)
    found = if @query.empty?
              value.nil? || value.to_s.empty?
            else
              value.to_s.include?(@query)
            end

    [found, (value if found)]
  end

  # Searches in an array
  # == Params:
  # - key: [String] Object to execute the search
  # == Result:
  # - [Boolean] Represents if a given key matched the given query
  def key_found?(key:)
    @query.empty? ? key.empty? : key.to_s.include?(@query)
  end

  # Search process for a Hash
  # == Params:
  # - result: [Hash] Stores the results
  # - key: [String] Hash key for the given search
  # - value:[Array, Hash, other] Object to execute a search
  # == Result:
  # - [Hash] Stores the results
  def search_within_hash(result:, key:, value:)
    if key_found?(key: key)
      result[key] = value
    else
      found, value = search_by_class(data: value)
      result[key] = value if found
    end

    result
  end
end
