require 'nokogiri'
require_relative '../app/models/task'
require_relative '../classes/task_xml_action'

# task xml file handler
class TaskXmlFile
  attr_reader :fname, :xml, :name, :uri, :description, :task, :actions

  def xml=(o)
    @xml = o.class == Array ? o.join(' ') : o
  end

  def parse_xml
    @doc = Nokogiri::XML.parse(self.xml)
    begin
      task = @doc.xpath('xmlns:Task')
    rescue Nokogiri::XML::XPath::SyntaxError
      return
    end

    info = task.xpath('xmlns:RegistrationInfo')
    @description = element_content(info, 'xmlns:Description')
    @uri = element_content(info, 'xmlns:URI')
    @name = File.basename(@uri).tr('\\', '')

    @actions = []
    execs = task.xpath('xmlns:Actions').xpath('xmlns:Exec')
    return if execs.nil?
    execs.each { |exec| @actions << TaskXMLAction.new(exec) }
  end

  def initialize(fname)
    @fname = fname.strip

    raise ArgumentError, 'File name must be provided' if self.fname.nil?
    raise ArgumentError, 'File name cannot be found' unless File.exist?(self.fname)

    self.xml = File.read(@fname).encode!('UTF-8', 'UTF-16', invalid: :replace)
    parse_xml

  end

  private

  def element_content(nodeset,e)
    node = nodeset.xpath(e).first
    node.nil? ? '' : node.content
  end
end
