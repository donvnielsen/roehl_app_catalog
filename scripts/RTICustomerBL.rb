require 'nokogiri'
require 'pp'
require_relative '../app/models/project'
require_relative '../app/models/project_project_index'

fnames = [File.join('..','spec','data','dockhours','projects','RTICustomerBL.csproj')]
puts fnames
puts File.exist?(fnames[0])

def parse_project_reference(ref)
  raise ArgumentError unless ref.is_a?(Nokogiri::XML::Element)
  rc = {file_name:ref['Include']}
  ref.element_children.each {|child|
    rc[:guid] = child.text.match(/\{(?<guid>.*)\}/)[:guid].downcase if child.name == "Project"
    rc[:name] = child.text if child.name == "Name"
  }
  rc
end


File.open(fnames[0]) {|f|
  doc = Nokogiri::XML(f) {|config| config.noblanks}
  pp doc
  prj = doc.xpath('xmlns:Project')
  puts '-'*70
  groups = prj.xpath('xmlns:ItemGroup')
  groups.each_with_index {|g,i|
    references = g.xpath('xmlns:Reference')
    projectreferences = g.xpath('xmlns:ProjectReference')
    puts sprintf(
             "%02d ref:%02d pref:%02d",i+1,
             references.nil? ? 0 : references.count,
             projectreferences.nil? ? 0 : projectreferences.count
         )
    unless projectreferences.nil? || projectreferences.count == 0
      # pp projectreferences
      projectreferences.each {|ref|
        pp parse_project_reference(ref)
        }
    end
  }

}
# pp csproj
puts '-'*70

# prj = doc.xpath('//xmlns:Project')
# pp prj.class
# pp prj.count

__END__

item_groups = csproj.xpath('//Project/ItemGroup')
pp item_groups
item_groups.each {|node|
  references = node.xpath('/Reference')
  puts references
}
