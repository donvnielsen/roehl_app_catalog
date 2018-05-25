require 'spec_helper'
require_relative '../../../app/models/project'

describe Project do

  before(:all) do
    @tname = 'load_csproj_file'
    @fname = File.join(TEST_PROJECT_FILE)
    DatabaseCleaner.clean
    @prj = Project.create( name:@tname, guid:@tname, file_name: @fname )
  end

  it 'should replace dir_name' do
    expect(@prj.dir_name).to eq(File.dirname(@fname))
  end
  it 'should replace ptype' do
    expect(@prj.ptype).to eq('csproj')
  end
  it 'should replace name' do
    expect(@prj.name).to eq(@tname)
  end

  it 'should load csproj file when file name is specified' do
    expect(@prj.csproj_file.is_a?(Array)).to be_truthy
  end

end