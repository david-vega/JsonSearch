require 'spec_helper'

describe SystemConsoleIO::JsonSearchIO do
  subject{ described_class.new }

  before do
    files_path = Dir[File.expand_path(File.join(SUPPORT_FILES_PATH, 'support','*.json'))]
    allow(Dir).to receive(:[]){ files_path }
  end

  it{ expect(subject.instance_variable_get(:@json_searchers).keys).to eq(
    %w[
      simple_array
      simple_string
      simple_hash
      mix_array_hash_string
    ])
  }
end
