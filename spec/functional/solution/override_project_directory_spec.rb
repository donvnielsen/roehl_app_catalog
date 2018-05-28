require 'spec_helper'
require_relative '../../../classes/solution_file'
require_relative '../../../app/models/project'

describe SolutionFile do
  before(:all) do
    DatabaseCleaner.clean
    Project.destroy_all
    @sf = SolutionFile.new(TEST_SOLUTION_FILE)
  end

  it 'should should override project file directory' do
    odir = File.join(SPEC_DATA_DIR, 'dockhours', 'projects')
    @sf.create_solution_projects(odir)
    expect(Project.last.dir_name).to eq(odir)
  end
end