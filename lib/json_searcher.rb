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
      find_in_string(string: data)
    end
  end

  def find_in_array(array:)
    array.map do |data|
      values = find_in_hash(hash: data)
      values if values.any?
    end.compact
  end

  def find_in_hash(hash:)
    hash.select do |key, value|
      key_found?(key: key) || value_found?(value: value)
    end
  end

  def find_in_string(string:)
    string if string.to_s.include?(@query)
  end

  def key_found?(key:)
    key.to_s.include?(@query)
  end

  def value_found?(value:)
    @query == 'null' && value.nil? || search_by_class(data: value)
  end
end