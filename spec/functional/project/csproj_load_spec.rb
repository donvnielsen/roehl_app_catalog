require 'spec_helper'
require_relative '../../../classes/csproj_file'
require 'nokogiri'

def extract_projects(fname)
  File.open(fname) {|f|
    doc = Nokogiri::XML(f) {|config| config.noblanks}
    prj = doc.xpath('xmlns:Project')
    groups = prj.xpath('xmlns:ItemGroup')
    groups.each_with_index {|g,i|
      prefs = g.xpath('xmlns:ProjectReference')
      return prefs unless prefs.nil?
    }
  }
  nil
end

describe CsprojFile do
  before(:all) do
    @name = 'RTIBusiness'
    @guid = 'd1311fbc-55d2-4556-9946-377d14f9a92d'
  end

  context 'Invalid constructors' do
    it 'raises exception when file omitted' do
      expect{CsprojFile.new(nil,nil,1)}.to raise_error(ArgumentError)
    end
    it 'raises exception when guid omitted' do
      expect{CsprojFile.new(@name, nil,1)}.to raise_error(ArgumentError)
    end
    it 'should raise exception when index is omitted' do
      expect{CsprojFile.new(@name, @guid,nil)}.to raise_error(ArgumentError)
    end
    it 'should raise exception when index less than zero' do
      expect{CsprojFile.new(@name, @guid,-1)}.to raise_error(ArgumentError)
    end
  end

  context 'Validate constructor' do
    before(:all) do
      DatabaseCleaner.clean
      @csproj = CsprojFile.new(TEST_PROJECT_FILE,@guid,0)
    end

    it 'should increment the index' do
      expect(@csproj.idx).to eq(1)
    end
    it 'should save the file name' do
      expect(@csproj.fname).to eq(TEST_PROJECT_FILE)
    end
    it 'should save the guid' do
      expect(@csproj.guid).to eq(@guid)
    end
    it 'should load the embedded project names' do
      expect(@csproj.projects.size).to eq(6)
    end

  end

  context 'project existence' do
    before(:all) do
      DatabaseCleaner.clean
    end
    it 'should create a project if it does not exist' do
      CsprojFile.new(TEST_PROJECT_FILE,@guid,0)
      expect(Project.count).to eq(1)
    end
    it 'should find an existing project' do
      expect{CsprojFile.new(TEST_PROJECT_FILE,@guid,0)}.to_not raise_error
      expect(Project.count).to eq(1)
    end
  end

  context 'Ensure all projects references identified' do
    before(:all) do
      DatabaseCleaner.clean
      @csproj = CsprojFile.new(TEST_PROJECT_FILE,@guid,0)
    end

    it 'should create project to project references' do
      @csproj.recurse_projects(File.join(File.join(SPEC_DIR,'data','dockhours','projects')))
      expect(Project.count).to eq(8)
    end
    # it 'should extract project references from csproj file' do
    #   @prefs.each {|pref|
    #     pp CsprojFile.parse_project_reference(pref)
    #     expect(Project.find_by_name(name).count).to eq(1)
    #   }
    # end
  end

end

