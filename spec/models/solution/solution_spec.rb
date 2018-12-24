require 'spec_helper'
require_relative '../../../app/models/solution'

describe Solution do
  before(:all) do
    DatabaseCleaner.clean
  end

  context 'names' do
    it 'should throw errors when columns are empty' do
      expect(Solution.create.valid?).to be_falsey
    end

    it 'should have error message when name is empty' do
      errors = Solution.create.errors
      expect(errors[:file_name]).to include("can't be blank")
      expect(errors[:dir_name]).to include("can't be blank")
      expect(errors[:guid]).to include("can't be blank")
    end
  end

  context 'uniqueness' do
    it 'should not throw error when all is ok' do
      expect(Solution.create(name:'test',file_name:'test',dir_name:'test',guid:'test').valid?)
          .to be_truthy
    end
    it 'should throw error when attempt to add duplicate name' do
      expect(Solution.create(name:'test',file_name:'test',dir_name:'test',guid:'test').valid?)
        .to be_falsey
    end
  end

  context 'data cleanse columns' do
    before(:all) do
      DatabaseCleaner.clean
      @vb = ' strip '.upcase
      @va = @vb.strip
      @task = Solution.create!(file_name: @vb, dir_name: @vb, guid: 'solution cleanse', name: 'solution cleanse')
    end

    it 'should strip leading/trailing whitespace from columns' do
      expect(@task[:file_name]).to eq(@vb.strip)
      expect(@task[:dir_name]).to eq(@vb.strip)
    end

    it 'should have an empty sln_file' do
      expect(@task[:sln_file].size).to eq(0)
    end

    it 'should have an empty guid' do
      expect(@task.guid.empty?).to be_falsey
    end

    it 'should have an sln_file' do
      expect(@task.sln_file.empty?).to be_truthy
    end

    it 'should have an empty name' do
      expect(@task.name.empty?).to be_falsey
    end
  end

  context 'create from file name that exists' do
    before(:all) do
      DatabaseCleaner.clean
      @fname = " #{TEST_SOLUTION_FILE} "
      @task = Solution.create_from_filename!(@fname)
    end

    it 'should parse the file name' do
      expect(@task.file_name).to eq(File.basename(@fname.strip))
    end

    it 'should parse the dir name' do
      expect(@task.dir_name).to eq(File.dirname(@fname.strip))
    end

    it 'should load the solution file' do
      expect(@task.sln_file.size).to be > 0
    end

    it 'should extract the name from first project' do
      expect(@task.name).to eq('spec_test_solution')
      # expect(@sln.name).to eq('AccountingPortal')
    end

    it 'should extract the guid form the first project' do
      expect(@task.guid).to eq('?')
      # expect(@sln.guid).to eq('fae04ec0-301f-11d3-bf4b-00c04f79efbc')
    end

    it 'should return nil unless solution file .sln' do
      expect(Solution.create_from_filename!(TEST_SOLUTION_FILE+'x')).to be_nil
    end

  end
end