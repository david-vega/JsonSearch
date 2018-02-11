require 'spec_helper'

describe SystemConsoleIO::JsonSearchIO do
  let(:exit_input_io){ '[[exit]]' }
  let(:help_input_io){ '[[help]]' }
  let(:no_results_io){ 'This string does not exist in the files' }
  let(:title){ 'Welcome to JsonSearch!'.bold }
  let(:introduction){ 'Enter "[[exit]]" to exit, or "[[help]]" for a full list of commands.' }
  let(:goodbye){ "\nGoodbye!".bold }
  let(:search){ "\nSearch:".bold.cyan }
  let(:no_results){ 'No results'.bold.red }
  let(:help_message) do
    "#{'Command  | Action'.bold}\n"\
        "#{'[[exit]]'.gray} | #{'Exits the application'.gray}\n" \
        "#{'[[help]]'.gray} | #{'Shows the help'.gray}\n"
  end

  subject{ described_class.new }

  before do
    files_path = Dir[File.expand_path(File.join(SUPPORT_FILES_PATH, 'support','*.json'))]
    allow(Dir).to receive(:[]){ files_path }
    allow(STDIN).to receive(:gets){ exit_input_io }
  end

  describe '#initialize' do
    it{ expect(subject.instance_variable_get(:@json_searchers).keys).to eq(
      %w[
        simple_array
        simple_string
        simple_hash
        mix_array_hash_string
      ])
    }
  end

  describe '#start' do
    subject{ super().start }

    context 'the exit command is passed' do
      it 'starts and exits the program' do
        expect(STDOUT).to receive(:puts).with("#{title}\n#{introduction}")
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(goodbye)
        subject
      end
    end

    context 'the help command is passed' do
      before{ allow(STDIN).to receive(:gets).and_return(help_input_io, exit_input_io) }

      it 'shows help message' do
        expect(STDOUT).to receive(:puts).with("#{title}\n#{introduction}")
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(help_message)
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(goodbye)
        subject
      end
    end

    context 'Search is not found' do
      before{ allow(STDIN).to receive(:gets).and_return(no_results_io, exit_input_io) }

      it 'shows help message' do
        expect(STDOUT).to receive(:puts).with("#{title}\n#{introduction}")
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(no_results)
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(goodbye)
        subject
      end
    end

    context 'Search is found in a single file' do
      let(:found){ "\n Found in: \"mix_array_hash_string\"".bold.green }
      let(:results){ "[\n    \e[1;37m[0] \e[0m{\n        \"email\"\e[0;37m => \e[0m\e[0;33m\"coffeyrasmussen@flotonic.com\"\e[0m\n    }\n]" }
      let(:single_result_io){ 'coffeyrasmussen@flotonic.com' }
      before{ allow(STDIN).to receive(:gets).and_return(single_result_io, exit_input_io) }

      it 'shows help message' do
        expect(STDOUT).to receive(:puts).with("#{title}\n#{introduction}")
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(found)
        expect(STDOUT).to receive(:puts).with(results)
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(goodbye)
        subject
      end
    end

    context 'Search is found in a multiple files' do
      let(:found_simple){ "\n Found in: \"simple_array\"".bold.green }
      let(:found_mix){ "\n Found in: \"mix_array_hash_string\"".bold.green }
      let(:result_simple){ "[\n    \e[1;37m[0] \e[0m\e[0;33m\"Babb\"\e[0m\n]" }
      let(:result_mix){ "[\n    \e[1;37m[0] \e[0m{\n        \"tags\"\e[0;37m => \e[0m[\n            \e[1;37m[0] \e[0m\e[0;33m\"Babb\"\e[0m\n        ]\n    }\n]" }
      let(:single_result_io){ 'Babb' }
      before{ allow(STDIN).to receive(:gets).and_return(single_result_io, exit_input_io) }

      it 'shows help message' do
        expect(STDOUT).to receive(:puts).with("#{title}\n#{introduction}")
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(found_simple)
        expect(STDOUT).to receive(:puts).with(result_simple)
        expect(STDOUT).to receive(:puts).with(found_mix)
        expect(STDOUT).to receive(:puts).with(result_mix)
        expect(STDOUT).to receive(:puts).with(search)
        expect(STDOUT).to receive(:puts).with(goodbye)
        subject
      end
    end
  end
end
