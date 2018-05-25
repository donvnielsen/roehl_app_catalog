require 'spec_helper'
require_relative '../../../classes/csproj_file'

describe CsprojFile do
  before(:all) do
    File.open(TEST_PROJECT_FILE) {|f|
      doc = Nokogiri::XML(f) {|config| config.noblanks}
      prj = doc.xpath('xmlns:Project')
      groups = prj.xpath('xmlns:ItemGroup')
      groups.each_with_index {|g,i|
        projectreferences = g.xpath('xmlns:ProjectReference')
        unless projectreferences.nil? || projectreferences.count == 0
          @ref = CsprojFile::parse_project_reference(projectreferences.first)
          break
        end
      }
    }
  end

  it 'should parse name from csproj xml' do
    expect(@ref[:name]).to eq('RTICommonV2.0')
  end
  it 'should parse guid from csproj xml' do
    expect(@ref[:guid]).to eq('b7e52da7-04f5-42dc-8d0b-7842c407b3ee')
  end
end