require 'spec_helper'
require_relative '../../config/environment'
require_relative '../../classes/solution_file'

describe SolutionFile::ProjectAttributes do
  context 'complex Roehl.sln' do
    before(:all) do
      o = 'Project("{00D1A9C2-B5F0-4AF3-8072-F6C62B433612}") = "Roehl", "Roehl.sqlproj", "{14D5AC93-8674-4D83-BAA6-D71E4B18CD42}"'
      @pa = SolutionFile::ProjectAttributes.new(o)
    end
    it 'should recognize complex file name' do
      expect(@pa.is_a?(SolutionFile::ProjectAttributes)).to be_truthy
    end
    it 'should parse project name' do
      expect(@pa.name).to eq('Roehl')
    end
    it 'should parse project type' do
      expect(@pa.type).to eq('sqlproj')
    end
  end

end