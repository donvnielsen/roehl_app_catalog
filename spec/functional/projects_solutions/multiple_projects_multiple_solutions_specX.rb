require 'spec_helper'
require_relative '../../../classes/solution_file'

TEST_PROJECT = 'RTICommonV2.0'

describe ProjectSolution do
  before(:all) do
    DatabaseCleaner.clean
    # ProjectSolution.destroy_all
    # Project.destroy_all
    # Solution.destroy_all
    tdir = File.join(File.dirname(__FILE__), 'data', '*.sln')
    puts tdir
    solution_files = Dir.glob(tdir).sort
    solution_files.each do |fname|
      @sf = SolutionFile.new(fname)
      next if @sf.nil?
      @sf.create_solution_projects
      @sf.create_new_solution_from_file
      @sf.relate_projects_to_solutions
    end
  end

  def test_solution_count(sln,qty)
    expect(ProjectSolution.where('solution_id = ?', sln.id).count).to eq(qty)
  end

  context 'multiple projects multiple solutions' do
    it 'should have two solutions' do
      expect(Solution.count).to eq(2)
    end
    it 'should have multiple projects' do
      expect(Project.count).to eq(10)
    end
    it 'should have 7 relations for solution01' do
      test_solution_count(Solution.find_by_name('solution01'),7)
    end
    it 'should have 8 relations for solution02' do
      test_solution_count(Solution.find_by_name('solution02'),8)
    end
  end

  context 'deleting a project' do
    before(:all) do
      Project.find_by_name(TEST_PROJECT).destroy
    end
    it 'should have removed the project' do
      expect(Project.find_by_name(TEST_PROJECT)).to be_nil
    end
    it "should remove #{TEST_PROJECT} relations from solution01" do
      test_solution_count(Solution.find_by_name('solution01'),6)
    end
    it "should remove #{TEST_PROJECT} relations from solution02" do
      test_solution_count(Solution.find_by_name('solution02'),7)
    end
  end

  context 'deleting a solution' do
    before(:all) do
      @sln2 = 'solution02'
      Solution.find_by_name(@sln2).destroy
    end
    it 'should have removed the solution' do
      expect(Solution.find_by_name(@sln2)).to be_nil
    end
    it 'should remove all relations after deleting solution02' do
      expect(Solution.find_by_name(@sln2)).to be_nil
    end
  end

end