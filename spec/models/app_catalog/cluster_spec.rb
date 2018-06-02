require 'spec_helper'
require_relative '../../../app/models/cluster'

describe Cluster do
  context 'should verify columns are populated' do
    it 'should throw errors when columns are empty' do
      expect(Cluster.new.valid?).to be_falsey
    end
    it 'should return errors when columns are empty' do
      errors = Cluster.create.errors
      expect(errors[:name]).to include("can't be blank")
    end
  end

  context 'uniqueness' do
    before(:all) do
      DatabaseCleaner.clean
      @name = 'uniqueness'
    end
    it 'should not throw an error when cluster is valid' do
      expect(Cluster.create(name: @name).valid?).to be_truthy
    end
    it 'should prevent duplicate clusters' do
      c = Cluster.create(name: @name).errors
      expect(c[:name]).to include('has already been taken')
    end
  end

  context 'data cleanse' do
    before(:all) do
      @vb = ' Cluster '
      @va = @vb.strip
      @cluster = Cluster.create(name:@vb,description:@vb)
    end
    it 'should strip leading/trailing whitespace from name' do
      expect(@cluster.name).to eq(@va.downcase)
    end
    it 'should strip leading/trailing whitespace from description' do
      expect(@cluster.description).to eq(@va)
    end
    it 'should lowercase the cluster name' do
      expect(@cluster.name).to eq(@va.downcase)
    end
  end

end