require 'spec_helper'
require_relative '../../../classes/service_xml_file'


describe 'Parse the service xml file' do
  context 'initialization' do
    it 'will throw error when file name not provided' do
      expect{ ServiceXmlFile.new(nil) }.to raise_error(ArgumentError)
    end
    it 'will throw error when file name is empty' do
      expect{ ServiceXmlFile.new('') }.to raise_error(ArgumentError)
    end
    it 'will throw error when file name not found' do
      expect{ ServiceXmlFile.new('x') }.to raise_error(ArgumentError)
    end
  end

  context 'extraction' do
    before(:all) do
      @svc = ServiceXmlFile.new(TEST_SERVICE_FILE)
    end

    it 'will extract the name' do
      expect(@svc.name).to eq('AdobeARMservice')
    end
    it 'will extract the display name' do
      expect(@svc.displayname).to eq('Adobe Acrobat Update Service')
    end
    it 'will extract the path name' do
      expect(@svc.pathname).to eq('C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\armsvc.exe')
    end
  end
end