require 'spec_helper'
require_relative '../../../app/models/project'

describe Project do
  before(:all) do
    DatabaseCleaner.start
  end
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'should verify columns are populated' do
    it 'should throw errors when columns are empty' do
      expect(Project.new.valid?).to be_falsey
    end
    it 'should have errors for columns missing' do
      errors = Project.create.errors
      expect(errors[:guid]).to include("can't be blank")
      expect(errors[:name]).to include("can't be blank")
    end
  end

  context 'uniqueness' do
    before(:each) do
      DatabaseCleaner.start
    end
    after(:each) do
      DatabaseCleaner.clean
    end

    it 'should not throw error when all is ok' do
      expect(Project.create(name:'prj',guid:'prj').valid?).to be_truthy
    end
    it 'should throw error when attempt to add duplicate guid' do
      expect(Project.create(name:'prj',guid:'prj').valid?).to be_truthy
      expect(Project.create(name:'prj',guid:'prj').errors[:guid])
          .to include('has already been taken')
    end
  end

  context 'data cleanse columns' do
    before(:all) do
      @vb = ' PRJ '.upcase
      @va = @vb.strip
      @prj = Project.create(name:@vb,guid:@vb,file_name:@vb,ptype:@vb)
    end

    it 'should strip leading/trailing whitespace' do
      expect(@prj[:guid]).to eq(@va.downcase)
      expect(@prj[:name]).to eq(@va)
      expect(@prj[:file_name]).to eq(@va)
      expect(@prj[:ptype]).to eq(@va.downcase)
    end
    it 'should downcase columns' do
      expect(@prj[:guid]).to eq(@va.downcase)
      expect(@prj[:ptype]).to eq(@va.downcase)
      expect(@prj[:file_name]).to eq(@va)
      expect(@prj[:name]).to eq(@va)
    end

    it 'should default csproj blob to nil' do
      expect(@prj[:csproj_file].nil?).to be_truthy
    end

    it 'should convert backslashes to forward slashes' do
      fname = 'c:\this\has\forward\slashes'
      prj = Project.new(name:'prj',guid:'prj',file_name:fname)
      prj.validate
      expect(prj[:file_name]).to eq(fname.gsub('\\','/'))
    end

    it 'remove periods from columns' do
      ptype = '.csproj'
      prj = Project.create(name:'prj',guid:'prj',ptype: ptype)
      prj.validate
      expect(prj[:ptype]).to eq(ptype.delete('.'))
    end

  end

  context 'test blob load' do
    before(:all) do
      DatabaseCleaner.clean
    end
    it 'should load csproj file into blob column' do
      prj = Project.create!(name:'blob',guid:'blob',file_name:TEST_PROJECT_FILE)
      # pp prj,prj.errors
      expect(prj[:csproj_file].size).to be > 0
    end
  end

  context 'populate elements from file name' do
    before(:all) do
      @project = Project.new(guid:'fname',file_name:TEST_PROJECT_FILE)
    end
    it 'should populate dir name' do
      expect(@project.dir_name).to eq(File.dirname(TEST_PROJECT_FILE))
    end
    it 'should populate file name' do
      expect(@project.name).to eq(File.basename(TEST_PROJECT_FILE,'.*'))
    end
    it 'should populate project type' do
      expect(@project.ptype).to eq(File.extname(TEST_PROJECT_FILE).delete('.'))
    end
    it 'should populate the file name' do
      expect(@project.file_name).to eq(TEST_PROJECT_FILE)
    end
  end
end