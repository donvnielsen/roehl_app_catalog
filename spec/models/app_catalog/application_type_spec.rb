require 'spec_helper'
require_relative '../../../app/models/application_type'

describe ApplicationType do
  before(:all) { DatabaseCleaner.clean }

  it 'should require name' do
    errors = ApplicationType.create.errors
    expect(errors[:name]).to include("can't be blank")
  end

  context 'name presence' do
    before(:all) do
      @vb = ' ApplicationType '
      @va = @vb.strip.downcase
    end

    it 'should lower case the name' do
      ApplicationType.create(name: @vb)
      expect(ApplicationType.last.name).to eq(@va)
    end

    it 'should validate name is unique' do
      errors = ApplicationType.create(name: @vb).errors
      expect(errors[:name]).to include('has already been taken')
    end
  end

  context 'description' do
    before(:all) do
      @desc = ' The Description  '
    end
    it 'should permit a description' do
      ApplicationType.create(name: 'App01',description: @desc)
      expect(ApplicationType.last.description).to eq(@desc.strip)
    end
    it 'should allow a blank description' do
      ApplicationType.create(name: 'App02',description: '')
      expect(ApplicationType.last.description).to eq('')
    end
  end

end