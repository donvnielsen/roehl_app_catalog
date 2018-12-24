require 'spec_helper'
require_relative '../../../app/models/task'

describe Task do
  before(:all) do
    DatabaseCleaner.clean
  end

  context 'create empty task' do
    it 'should throw errors when columns are empty' do
      expect(Task.create.valid?).to be_falsey
    end

    it 'should have error message when task is empty' do
      errors = Task.create.errors
      expect(errors[:name]).to include("can't be blank")
      expect(errors[:uri]).to include("can't be blank")
      expect(errors[:xml]).to include("can't be blank")
    end
  end

  context 'data cleanse columns' do
    before(:all) do
      DatabaseCleaner.clean
      @vb = ' strip '.upcase
      @va = @vb.strip
      @task = Task.create!(name: @vb, uri: @vb, description: @vb, xml: @vb)
    end

    it 'should strip leading/trailing whitespace from columns' do
      expect(@task[:name]).to eq(@vb.strip)
      expect(@task[:uri]).to eq(@vb.strip)
      expect(@task[:description]).to eq(@vb.strip)
    end

    it 'should have saved the xml' do
      expect(@task.xml.empty?).to be_falsey
    end

  end

  context 'create from file name that exists' do
    before(:all) do
      DatabaseCleaner.clean
      @fname = " #{TEST_TASK_FILE} "
      @task = Task.new
      @task.create_from_filename!(TaskXmlFile.new(@fname))
    end

    after(:all) do
      @task.save
    end

    it 'will populate the uri' do
      expect(@task.uri).to eq('\RTIViaPointVerification')
    end

    it 'will populate the name' do
      expect(@task.name).to eq('RTIViaPointVerification')
    end

    it 'will populate the description' do
      expect(@task.description.size).to be > 0
    end

    it 'will populate xml from file' do
      expect(@task.xml.size).to be > 0
    end

  end
end
