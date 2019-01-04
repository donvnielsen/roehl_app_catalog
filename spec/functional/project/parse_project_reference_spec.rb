require 'spec_helper'
require_relative '../../../classes/csproj_file'

describe CsprojFile do
  before(:all) do
    File.open(TEST_PROJECT_FILE) {|f|
      doc = REXML::Document.new f
      project_references = REXML::XPath.match(doc, 'Project/ItemGroup/ProjectReference')
      unless project_references.nil? || project_references.count == 0
        @ref = CsprojFile::parse_project_reference(project_references.first)
        break
      end
    }
  end

  it 'should parse name from csproj xml' do
    expect(@ref[:name]).to eq('RTICommonV2.0')
  end
  it 'should parse guid from csproj xml' do
    expect(@ref[:guid]).to eq('b7e52da7-04f5-42dc-8d0b-7842c407b3ee')
  end
end