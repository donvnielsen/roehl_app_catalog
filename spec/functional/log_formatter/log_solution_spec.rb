require 'spec_helper'
require_relative '../../../classes/log_formatter/log_solution'

describe LogSolution do
  before(:all) do
    DatabaseCleaner.clean
  end

  context 'log solution' do
    it 'should format log with solution following' do
      sln = Solution.new(guid:'guid',name:'name',file_name:__FILE__)
      SPEC_LOGGER.warn LogSolution.msg(sln,'this is a test')
      SPEC_LOG_FILE.rewind
      expect(SPEC_LOG_FILE.read.index('Solution:')).to be > 0
    end
  end
end