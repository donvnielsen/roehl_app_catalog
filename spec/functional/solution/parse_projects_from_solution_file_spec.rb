require 'spec_helper'
require_relative '../../../classes/solution_file'

describe SolutionFile do
  let(:projects) {
    # $projects = SolutionFile.parse_projects_from_file(
    #     File.readlines(File.join(SPEC_DIR,'data','dockhours','solutions','RTIAzmanWS.sln')).map {|ln| ln.chomp}
    $projects = SolutionFile.parse_projects_from_file(
        File.readlines(TEST_SOLUTION_FILE).map {|ln| ln.chomp}
    )
  }

  context 'Parsing projects from file' do
    it 'should parse project references from file' do
      expect(projects.size).to eq(7)
    end

    it 'should contain four elements' do
      [:sln_guid,:prj_guid,:fname,:name].each {|e|
        expect(projects[0].respond_to?(e)).to be_truthy
      }
    end

    it 'should contain and instance of ProjectAttributes' do
      expect(projects[0].is_a?(SolutionFile::ProjectAttributes)).to be_truthy
    end

    it 'should parse a solution guid' do
      expect(projects[0].sln_guid).to eq('FAE04EC0-301F-11D3-BF4B-00C04F79EFBC'.downcase)
    end
    it 'should parse a project guid' do
      expect(projects[0].prj_guid).to eq('9DEA93B2-E905-42FF-AB96-F714B5BC72AF'.downcase)
    end
    it 'should parse a project fname' do
      expect(projects[0].fname).to eq('AccountingPortal.csproj')
    end
    it 'should parse a project name' do
      expect(projects[0].name).to eq('AccountingPortal')
    end
  end

end