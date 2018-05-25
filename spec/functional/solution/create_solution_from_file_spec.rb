require 'spec_helper'
require_relative '../../../classes/solution_file'

describe SolutionFile do
  context 'SolutionFile creates solution' do
    before(:all) do
      DatabaseCleaner.clean
      Solution.destroy_all
      @sf = SolutionFile.new(TEST_SOLUTION_FILE)
      @sf.create_new_solution_from_file
    end
    it 'should create solution file' do
      expect(Solution.count).to eq(1)
    end
  end

end


