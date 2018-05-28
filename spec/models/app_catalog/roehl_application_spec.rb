require 'spec_helper'
require_relative '../../../app/models/roehl_application'

describe RoehlApplication do
  before(:all) do
    DatabaseCleaner.start
  end
  after(:all) do
    DatabaseCleaner.clean
  end

  context 'should verify columns are populated' do
    it 'should throw errors when columns are empty' do
      expect(RoehlApplication.new.valid?).to be_falsey
    end
    it 'should have errors for columns missing' do
      errors = RoehlApplication.create.errors
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
      expect(RoehlApplication.create(name:'RoehlApplication').valid?).to be_truthy
    end
    it 'should throw error when attempt to add duplicate guid' do
      expect(RoehlApplication.create(name:'app').valid?).to be_truthy
      expect(RoehlApplication.create(name:'app').errors[:name])
          .to include('has already been taken')
    end
  end

  context 'data cleanse columns' do
    before(:all) do
      @vb = ' App '
      @va = @vb.strip
      @app = RoehlApplication.create(name:@vb,description:@vb)
    end

    it 'should strip leading/trailing whitespace' do
      expect(@app[:name]).to eq(@va.downcase)
      expect(@app[:description]).to eq(@va)
    end
    it 'should downcase columns' do
      expect(@app[:name]).to eq(@va.downcase)
    end
  end

end