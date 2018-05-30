require 'spec_helper'
require_relative '../../../app/models/project_project_index'
require_relative '../../../app/models/project'
require_relative '../../../classes/csproj_file'

def test_prj_prj_ref(csproj_id,name)
  expect(ProjectProject.where(
      'project_id=? and project_ref_id=?',
      csproj_id,
      Project.find_by_name(name).id
    ).count
  ).to eq(1)
end

describe ProjectProject do

  context 'id presence' do
    before(:all) { DatabaseCleaner.clean }

    it 'should throw errors when columns are empty' do
      errors = ProjectProject.create().errors
      expect(errors[:project_id]).to include("can't be blank")
      expect(errors[:project_ref_id]).to include("can't be blank")
    end

  end

  context 'project presence' do

    before(:all) do
      DatabaseCleaner.clean
      @tname = 'index proj id test'
      @prj1 = Project.create!(name:@tname,guid:@tname+'_1')
    end

    it 'should throw error when project id is known, project reference id unknown' do
      errors = ProjectProject.create(project_id:0,project_ref_id:0).errors
      expect(errors[:project_id]).to include(Project::ERR_INVALID_ID)
      expect(errors[:project_ref_id]).to include(Project::ERR_INVALID_ID)
    end
    it 'should throw error when project id is unknown' do
      @prj2 = Project.create!(name:@tname,guid:@tname+'_2')
      errors = ProjectProject.create(project_id:@prj1.id,project_ref_id:@prj2.id).errors
      expect(errors[:project_ref_id]).to be_empty
    end
  end

  context 'create project project references' do
    before(:all) do
      DatabaseCleaner.clean
      csproj = CsprojFile.new(TEST_PROJECT_FILE,'PrjPrj Ref')
      csproj.recurse_projects(File.join(SPEC_DATA_DIR,'dockhours','projects'))
    end
    it 'should create the projects' do
      expect(Project.count).to eq(8)
    end
    it 'should create project project relations' do
      expect(ProjectProject.count).to eq(10)
    end

    it 'should have csproj references' do
      csproj_id = Project.find_by_name('spec_test_project').id
      ['RTICommonV2.0',
       'RTIFrameworkHelperV2.0',
       'RTIFrameworkV1.0',
       'RTIFrameworkV2.0',
       'RTIWebCommon',
       'RTIGPUtility'
      ].each {|name| test_prj_prj_ref(csproj_id,name) }
    end

    it 'should have FrameworkHelper recursed refereces' do
      csproj_id = Project.find_by_name('RTIFrameworkHelperV2.0').id
      ['RTICommonV2.0',
       'RTIFrameworkV2.0',
       'RTICommon'
      ].each {|name| test_prj_prj_ref(csproj_id,name) }
    end

    it 'should have GPUtility recursed refereces' do
      prj = Project.find_by_name('RTIGPUtility')
      ['RTIFrameworkV2.0'].each {|name| test_prj_prj_ref(prj.id,name) }
    end
  end
end