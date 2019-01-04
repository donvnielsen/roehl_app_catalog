require 'pp'
require 'rexml/document'
include REXML

fname = 'C:\Users\niedo\Documents\roehl_app_catalog_test_data\dockhours\projects\accountingportal.csproj'
puts File.exist?(fname)

=begin
File.open(fname) {|f|
  doc = Nokogiri::XML(f) {|config| config.noblanks}
  prj = doc.xpath('xmlns:Project')
  groups = prj.xpath('xmlns:ItemGroup')
  groups.each_with_index {|g,i|
    prefs = g.xpath('xmlns:ProjectReference')
    return prefs unless prefs.nil?
  }
}
=end

File.open(fname) do |f|
  doc = REXML::Document.new f
  pp XPath.match(doc, 'Project/ItemGroup/ProjectReference')
end
