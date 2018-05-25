require 'spec_helper'
require_relative '../../../classes/solution_file'
require_relative '../../../app/models/project'

describe SolutionFile do
  before(:all) do
    DatabaseCleaner.clean
    Project.destroy_all
    @sf = SolutionFile.new(TEST_SOLUTION_FILE)
    @sf.create_solution_projects
  end

  context 'relate projects to solution' do
    it 'should have project id in attributes' do
      expect(@sf.projects.first.respond_to?(:id)).to be_truthy
    end
    it 'should add the id to attributes' do
      last_prj = Project.last
      x = nil
      @sf.projects.each {|p|
        if p.name.casecmp(last_prj.name) == 0
          x = p
          break
        end
      }
      expect(x.id).to eq(last_prj.id)
    end
  end

  it 'should have created projects' do
    expect(Project.count).to eq(7)
  end
end