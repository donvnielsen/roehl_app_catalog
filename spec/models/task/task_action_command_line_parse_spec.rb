require 'spec_helper'
require_relative '../../../app/models/task_action'

describe 'Tests cmd line regex parser' do

  context 'program within quotes followed by params' do
    before(:all) do
      @regex = TaskAction::PARSE_CMD_LINE_STRING.match('"c:/folder/program.exe" -a -b')
    end

    it 'will identify the executable' do
      expect(@regex[1]).to eq 'c:/folder/program.exe'
    end

    it 'will identify parameters' do
      expect(@regex[3]).to eq '-a -b'
    end
  end

  context 'program without quotes followed by params' do
    before(:all) do
      @regex = TaskAction::PARSE_CMD_LINE_STRING.match('c:/folder/program.exe -a -b')
    end

    it 'will identify the executable' do
      expect(@regex[2]).to eq 'c:/folder/program.exe'
    end

    it 'will identify parameters' do
      expect(@regex[3]).to eq '-a -b'
    end
  end

  context 'program within quotes' do
    before(:all) do
      @regex = TaskAction::PARSE_CMD_LINE_STRING.match('"c:/folder/program.exe"')
      pp @regex
    end

    it 'will identify the executable' do
      expect(@regex[1]).to eq 'c:/folder/program.exe'
    end

    it 'will identify parameters' do
      expect(@regex[3].nil?).to be_truthy
    end
  end

  context 'program without quotes' do
    before(:all) do
      @regex = TaskAction::PARSE_CMD_LINE_STRING.match('c:/folder/program.exe')
      pp @regex
    end

    it 'will identify the executable' do
      expect(@regex[2]).to eq 'c:/folder/program.exe'
    end

    it 'will identify parameters' do
      expect(@regex[3].nil?).to be_truthy
    end
  end

end