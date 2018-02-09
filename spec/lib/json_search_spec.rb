require 'spec_helper'

describe JsonSearcher do
  let(:support_files_path){ File.expand_path('..', File.dirname(__FILE__)) }
  let(:simple_hash_path) { File.join(support_files_path, 'support', 'simple_hash.json') }
  let(:simple_array_path) { File.join(support_files_path, 'support', 'simple_array.json') }
  let(:simple_string_path) { File.join(support_files_path, 'support', 'simple_string.json') }

  context 'when is a simple hash' do
    subject{ described_class.new(file_name: simple_hash_path) }

    it{ expect(subject.data).to eq JSON.parse(File.read(simple_hash_path)) }

    describe '#find' do
      let(:query){ 'Mega' }
      subject{ super().find(query: query) }

      context 'search close single match' do
        it{ is_expected.to eq({ 'details' => 'MegaCorp' }) }
      end

      context 'search close multiple match' do
        let(:query){ '8' }
        it do
          is_expected.to eq({
            'external_id' => '9270ed79-35eb-4a38-a46f-35725197ea8d',
            'created_at' => '2016-05-21T11:10:28 -10:00'
          })
        end
      end

      context 'search by single key' do
        let(:query){ 'domain_names' }
        it{ is_expected.to eq({ 'domain_names' => nil }) }
      end

      context 'search by multiple key' do
        let(:query){ '_id' }
        it do
          is_expected.to eq({
            '_id' => 101,
            'external_id' => '9270ed79-35eb-4a38-a46f-35725197ea8d'
          })
        end
      end
    end
  end

  describe 'when is an array' do
    subject{ described_class.new(file_name: simple_array_path) }

    xit{}
  end

  describe 'when is an string' do
    subject{ described_class.new(file_name: simple_string_path) }

    xit{}
  end
end
