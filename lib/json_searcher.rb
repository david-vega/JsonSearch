require 'json'

class JsonSearcher
  attr_reader :data

  def initialize(file_name:)
    @file_name = file_name
    @data = JSON.parse(File.read(@file_name))
  end

  def find(query:)
    @query = query

    case @data.class.to_s
    when 'Array'
      find_in_array(array: @data)
    when 'Hash'
      find_in_hash(hash: @data)
    else
      find_in_string(string: @data)
    end
  end

  private

  def find_in_array(array:)
    array.map do |data|
      #TODO complete this method
    end.compact
  end

  def find_in_hash(hash:)
    hash.select do |key, value|
      key_found?(key: key) || value_found?(value: value)
    end
  end

  def find_in_string(string:)
    #TODO complete this method
  end

  def key_found?(key:)
    key.to_s.include?(@query)
  end

  def value_found?(value:)
    @query == 'null' && value.nil? || value.to_s.include?(@query)
  end
end