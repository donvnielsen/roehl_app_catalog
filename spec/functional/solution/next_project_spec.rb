require 'spec_helper'
require_relative '../../../classes/solution_file'

describe SolutionFile do

  context 'project block ok' do
    it 'should return an array of next project' do
      ary = ['Project()','EndProject']
      result = SolutionFile.next_project!(ary)
      expect(result.kind_of? Array).to eq(true)
      expect(result.size).to eq(2)
    end

    it 'should not throw error when text after group' do
      ary = ['Project()',' one',' two','EndProject','something else']
      result = ''
      expect{result = SolutionFile.next_project!(ary)}.to_not raise_error
      expect(result.size).to eq(4)
    end

    it 'should not throw error when there is no block' do
      ary = ['x','y','z']
      result = ''
      expect{result = SolutionFile.next_project!(ary)}.to_not raise_error
      expect(result.nil?).to be_truthy
    end
  end

  context 'project block not ok' do
    it 'should throw error when eof without EndProject' do
      ary = ['Project()',' ',' ']
      expect{SolutionFile.next_project!(ary)}.to raise_error(ArgumentError)
    end

    it 'should throw error when line does not begin with blank' do
      ary = ['Project()','x','EndProject']
      expect{SolutionFile.next_project!(ary)}.to raise_error(ArgumentError)
    end

    it 'should throw error when line does not begin with blank' do
      ary = ['Project()',' one',' two','EndProject']
      expect{SolutionFile.next_project!(ary)}.to_not raise_error
    end
  end

end