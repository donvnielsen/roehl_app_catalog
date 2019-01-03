require 'spec_helper'
require_relative '../../../app/models/service'

describe Service do

  context 'create an empty service' do
    it 'will throw errors when required columns are empty' do
      expect(Service.create.valid?).to be_falsey
    end
    it 'will have error messages when columns are empty' do
      errors = Service.create.errors
      expect(errors[:name]).to include("can't be blank")
      expect(errors[:pathname]).to include("can't be blank")
      expect(errors[:xml]).to include("can't be blank")
    end
  end

  context 'data cleanse columns' do
    before(:all) do
      DatabaseCleaner.clean
      @vb = ' strip '.upcase
      @va = @vb.strip
      @service = Service.create!(name: @vb, pathname: @vb, description: @vb, xml: @vb)
    end

    it 'should strip leading/trailing whitespace from columns' do
      expect(@service[:name]).to eq(@vb.strip.downcase)
      expect(@service[:pathname]).to eq(@vb.strip)
      expect(@service[:description]).to eq(@vb.strip)
    end

    it 'should have saved the xml' do
      expect(@service[:xml]).to eq(@vb)
    end
  end


end