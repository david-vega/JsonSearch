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
        it{ is_expected.to eq([true, { 'details' => 'MegaCorp' }]) }
      end

      context 'search close multiple match' do
        let(:query){ '8' }
        it do
          is_expected.to eq([
            true, {
              'external_id' => '9270ed79-35eb-4a38-a46f-35725197ea8d',
              'created_at' => '2016-05-21T11:10:28 -10:00'
            }
          ])
        end
      end

      context 'search by single key' do
        let(:query){ 'domain_names' }
        it{ is_expected.to eq([true, { 'domain_names' => nil }]) }
      end

      context 'search by multiple key' do
        let(:query){ '_id' }
        it do
          is_expected.to eq([
            true, {
              '_id' => 101,
              'external_id' => '9270ed79-35eb-4a38-a46f-35725197ea8d'
            }
          ])
        end
      end

      context 'search a false bolean' do
        let(:query){ 'false' }
        it{ is_expected.to eq([true, { 'shared_tickets' => false }]) }
      end

      context 'search a true bolean' do
        let(:query){ 'true' }
        it{ is_expected.to eq([true, { 'shared_account' => true }]) }
      end

      context 'search by null and empty values' do
        let(:query){ '' }
        it do
          is_expected.to eq([
            true, {
              'domain_names' => nil,
              'tags' => nil,
              '' => 'empty key',
              'empty_value' => ''
            }
          ])
        end
      end

      context 'no match' do
        let(:query){ 'Foo Bar' }
        it do
          is_expected.to eq([false, {}])
        end
      end
    end
  end

  describe 'when is an array' do
    subject{ described_class.new(file_name: simple_array_path) }

    it{ expect(subject.data).to eq JSON.parse(File.read(simple_array_path)) }

    describe '#find' do
      let(:query){ 'le' }
      subject{ super().find(query: query) }
  
      context 'search close match' do
        it{ is_expected.to eq([true, ['Idledale', 'Allendale']]) }
      end

      context 'search exact match' do
        let(:query){ 'Idledale' }
        it{ is_expected.to eq([true, ['Idledale']]) }
      end

      context 'the full query does not exist' do
        let(:query){ 'Idledale Foo Bar' }
        it{ is_expected.to eq([false, []]) }
      end

      context 'the full query does not exist' do
        let(:query){ 'Idledale Foo Bar' }
        it{ is_expected.to eq([false, []]) }
      end

      context 'search a false bolean' do
        let(:query){ 'false' }
        it{ is_expected.to eq([true, [false]]) }
      end

      context 'search a true bolean' do
        let(:query){ 'true' }
        it{ is_expected.to eq([true, [true]]) }
      end

      context 'search by null and empty values ' do
        let(:query){ '' }
        it{ is_expected.to eq([true, ['', nil]]) }
      end
    end
  end

  describe 'when is an string' do
    subject{ described_class.new(file_name: simple_string_path) }

    it{ expect(subject.data).to eq JSON.parse(File.read(simple_string_path)) }

    describe '#find' do
      let(:query){ 'Json' }
      subject{ super().find(query: query) }

      context 'search close match' do
        let(:query){ 'This is a Json string' }
        it{ is_expected.to eq([true, 'This is a Json string']) }
      end

      context 'search exact match' do
        let(:query){ 'This is a Json string' }
        it{ is_expected.to eq([true, 'This is a Json string']) }
      end

      context 'the full query does not exist' do
        let(:query){ 'This is a Json string # the whole string is not included' }
        it{ is_expected.to eq([false, nil]) }
      end

      context 'no match' do
        let(:query){ 'Foo Bar' }
        it{ is_expected.to eq([false, nil]) }
      end
    end
  end
end
