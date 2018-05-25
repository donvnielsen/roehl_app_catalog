require 'spec_helper'
require_relative '../../../classes/build_manager/build_def'

describe BuildDef do
  before(:all) do
    fname = File.join(BUILDMGR_DIR,'simple_builds.xml')
    @doc = File.open(fname) {|f| Nokogiri::XML(f) }
    @buildmgr = @doc.xpath('xmlns:BuildManagerData')
  end

  context 'initialize' do
    it 'should throw error when not xml node' do
      expect{BuildDef.new(nil)}.to raise_error(ArgumentError)
    end
    it 'should accept an xml builds element' do
      expect{BuildDef.new(@buildmgr.xpath('xmlns:Builds').first)}.to_not raise_error
    end
  end

  context 'parsing of information' do
    before(:all) do
      @bdef = BuildDef.new(@buildmgr.xpath('xmlns:Builds').first)
    end

    it 'should return target properties as a hash' do
      expect(@bdef.properties.is_a?(Hash)).to be_truthy
    end
    it 'should have parsed keys' do
      [:localbuildfolder,:webfolder,:server,:appname].each {|p|
        expect(@bdef.properties.include?(p.downcase)).to be_truthy
      }
    end
    it 'should return target name' do
      expect(@bdef.target_name).to eq('DeployRTIEDIConsoleApp')
    end
    it 'should return friendly name' do
      expect(@bdef.friendly_name).to eq('Target Name Friendly')
    end
  end

  context 'getting server name' do
    before(:all) do
      @bdef = BuildDef.new(@buildmgr.xpath('xmlns:Builds').first)
    end

    it 'should return server name' do
      expect(@bdef.server_name).to eq('MFDAN0001')
    end

    it 'should return nothing when there is no server name to return' do
      @bdef.properties.delete(:server)
      expect(@bdef.server_name.nil?).to be_truthy
    end
  end

  context 'getting app name' do
    before(:all) do
      @bdef = BuildDef.new(@buildmgr.xpath('xmlns:Builds').first)
    end

    it 'should return server name' do
      expect(@bdef.app_name).to eq('RTIEDIConsoleApp')
    end

    it 'should return nothing when there isnt an app name to return' do
      @bdef.properties.delete(:server)
      expect(@bdef.server_name.nil?).to be_truthy
    end
  end
end