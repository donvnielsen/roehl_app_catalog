require 'spec_helper'
require_relative '../../../app/models/server'

describe Server do
  before(:all) do
    DatabaseCleaner.start
  end
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'should verify columns are populated' do
    it 'should throw errors when columns are empty' do
      expect(Server.new.valid?).to be_falsey
    end
    it 'should have errors for columns missing' do
      errors = Server.create.errors
      expect(errors[:name]).to include("can't be blank")
    end
  end

  context 'uniqueness' do
    before(:each) do
      DatabaseCleaner.start
    end
    after(:each) do
      DatabaseCleaner.clean
    end

    it 'should not throw error when all is ok' do
      expect(Server.create(name:'server').valid?).to be_truthy
    end
    it 'should throw error when attempt to add duplicate guid' do
      expect(Server.create(name:'prj').valid?).to be_truthy
      expect(Server.create(name:'prj').errors[:name])
          .to include('has already been taken')
    end
  end

  context 'data cleanse columns' do
    before(:all) do
      @vb = ' Server '
      @va = @vb.strip
      @server = Server.create(name:@vb,description:@vb)
    end

    it 'should strip leading/trailing whitespace' do
      expect(@server[:name]).to eq(@va.downcase)
      expect(@server[:description]).to eq(@va)
    end
    it 'should downcase columns' do
      expect(@server[:name]).to eq(@va.downcase)
    end

  end

end