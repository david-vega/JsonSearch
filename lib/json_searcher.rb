require 'json'

class JsonSearcher
  attr_reader :data

  def initialize(file_name:)
    @file_name = file_name
    @data = JSON.parse(File.read(@file_name))
  end

  def find(query:)
    @query = query

    search_by_class(data: @data)
  end

  private
  
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

  def find_in_array(array:)
    result = array.inject([]) do |result, data|
               found, value = search_by_class(data: data)
               result << value if found
               result
             end
    
    # when result = [false], result.any? => false :(
    [!result.empty?, result]
  end

  def find_in_hash(hash:)
    result = hash.inject({}) { |result, (key, value)| search_within_hash(result: result, key: key, value: value) }

    [result.any?, result]
  end

  def find_in_value(value:)
    found = if @query.empty?
              value.nil? || value.to_s.empty?
            else
              value.to_s.include?(@query)
            end
    
    [found, (value if found)]
  end

  def key_found?(key:)
    @query.empty? ? key.empty? : key.to_s.include?(@query)
  end

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
