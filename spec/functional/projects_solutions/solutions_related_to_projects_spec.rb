require 'spec_helper'
require_relative '../../../classes/solution_file'
require_relative '../../../app/models/projects_solutions_index'

describe ProjectSolution do
  before(:all) do
    DatabaseCleaner.clean
    Solution.create(guid:'guid',name:'name',dir_name:'x',file_name:'x').errors
    Project.create(guid:'guid',name:'name',dir_name:'x',file_name:'x').errors
    ProjectSolution.destroy_all
    @spi = ProjectSolution.new(solution_id:Solution.last.id, project_id:Project.last.id)
  end

  context 'relate solution to projects' do
    it 'should create relations' do
      expect{@spi.save!}.to_not raise_error
    end
    it 'should have one row' do
      expect(ProjectSolution.count).to eq(1)
    end
  end

  context 'trap duplicates' do
    it 'should catch when a duplicate row is attempted' do
      spi = ProjectSolution.create(solution_id:Solution.last.id, project_id:Project.last.id)
      expect(spi.errors[:project_id].size).to be > 0
    end
  end

end