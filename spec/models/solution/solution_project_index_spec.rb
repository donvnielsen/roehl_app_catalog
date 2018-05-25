require 'spec_helper'
require_relative '../../../app/models/projects_solutions_index'
require_relative '../../../app/models/solution'
require_relative '../../../app/models/project'
require 'securerandom'

describe ProjectSolution do
  context 'id presence' do
    before(:all) do
      DatabaseCleaner.clean
    end
    it 'should throw errors when columns are empty' do
      errors = ProjectSolution.create.errors
      expect(errors[:solution_id]).to include("can't be blank")
      expect(errors[:project_id]).to include("can't be blank")
    end
  end

  context 'solution presence' do
    before(:all) do
      DatabaseCleaner.clean
    end
    it 'should throw error when solution id is unknown' do
      errors = ProjectSolution.create(solution_id:0, project_id:0).errors
      expect(errors[:solution_id]).to include(Solution::ERR_INVALID_ID)
      expect(errors[:project_id]).to include(Project::ERR_INVALID_ID)
    end
    it 'should throw error when solution id is known, project id unknown' do
      tname = 'index sol id test'
      sln = Solution.create(name:tname,file_name:tname,dir_name:tname,
                            guid:SecureRandom.uuid)
      expect{ProjectSolution.create!(solution_id:sln, project_id:99)}
          .to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'should throw error when solution id is unknown' do
      tname = 'index prj id test'
      sln = Solution.create(name:tname,file_name:tname,dir_name:tname,
                            guid:SecureRandom.uuid)
      prj = Project.create(guid:tname,name:tname)
      expect{ProjectSolution.create!(solution_id:sln.id, project_id:prj.id)}
          .to_not raise_error
    end
  end

  context 'uniqueness' do
    before(:all) do
      DatabaseCleaner.clean
      tname = 'solution|project uniqueness'
      Solution.create!(name:tname,file_name:tname,dir_name:tname,guid:tname)
      Project.create!(name:tname,guid:tname)
    end
    it 'should throw error with duplicate entry' do
      ProjectSolution.create!(solution_id:Solution.last.id,
                              project_id:Project.last.id)
      expect{ProjectSolution.create!(solution_id:Solution.last.id,
                                     project_id:Project.last.id)}
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end