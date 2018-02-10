ENV['RACK_ENV'] = 'test'
require File.join(File.expand_path('..', File.dirname(__FILE__)), 'config', 'env.rb')

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

SUPPORT_FILES_PATH = File.expand_path(File.dirname(__FILE__)).freeze
