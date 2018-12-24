require 'spec_helper'
require_relative '../../../classes/task_xml_file'

describe 'task_xml_file' do

  context 'initialization' do
    it 'should throw errors when columns are empty' do
      expect { TaskXmlFile.new('') }.to raise_error(ArgumentError)
    end
  end

  context 'loading file' do
    before(:all) do
      @task = TaskXmlFile.new(TEST_TASK_FILE)
    end
    it 'will extract name' do
      expect(@task.name).to eq('RTIViaPointVerification')
    end
    it 'will extract uri' do
      expect(@task.uri).to eq('\RTIViaPointVerification')
    end
    it 'will extract description' do
      expect(@task.description).to eq('Verifies ViaPoint lat/long values against tbCompanyCityMaster lat/long values')
    end
    it 'will save copy of xml' do
      expect(@task.xml).to_not be_empty
    end

    context 'actions' do
      it 'will extract actions' do
        expect(@task.actions.count).to eq(1)
      end
      it 'will extract command from action' do
        expect(@task.actions.first.command).to eq('C:\\RoehlPrograms\\RTIViapointVerification\\RTIViaPointVerification.exe')
        expect(@task.actions.first.arguments).to eq('')
      end
    end
  end

end
