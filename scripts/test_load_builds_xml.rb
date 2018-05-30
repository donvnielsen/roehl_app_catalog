require 'nokogiri'
require_relative '../classes/build_manager/build_def'
require_relative '../app/models/server'
require 'pp'

File.open(File.join('..','spec','data','build_manager','BuildManager.xml')) {|f|
  doc = Nokogiri::XML(f) {|config| config.noblanks}
  buildmgr = doc.xpath('xmlns:BuildManagerData')
  begin
    builds = buildmgr.xpath('xmlns:Builds')
    builds.each_with_index {|b, i|
      build = BuildDef.new(b)
      server = Server.find_by_name(build.server_name) ||
        Server.create(name: build.server_name)
      pp server
      break
    }
    # pp builds
  rescue Nokogiri::XML::XPath::SyntaxError
    return
  end
  # groups = prj.xpath('xmlns:ItemGroup')
  # groups.each_with_index {|g,i|
  #   projectreferences = g.xpath('xmlns:ProjectReference')
  #   unless projectreferences.nil? || projectreferences.count == 0
  #     projectreferences.each {|prjref|
  #       @projects << CsprojFile.parse_project_reference(prjref)
  #     }
  #   end
}

