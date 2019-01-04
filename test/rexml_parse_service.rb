require 'pp'
require 'rexml/document'

fname = 'test_service_export.xml'
puts File.exist?(fname)

File.open(fname) do |f|
  doc = REXML::Document.new f
  props = REXML::XPath.match(doc, '/Objs/Obj/Props').first
  ['Name','PathName','DisplayName'].each { |e|
    svcs = props.elements["S[@N='#{e}']"]
    pp svcs.text.tr('\\', '/').tr('"','')
  }
end