require 'rexml/document'
require_relative '../app/models/task'
require_relative '../classes/task_xml_action'

# task xml file handler
class TaskXmlFile
  attr_reader :fname, :xml, :name, :uri, :description, :task, :actions

  def xml=(o)
    @xml = o.class == Array ? o.join(' ') : o
  end

  def parse_xml
    @doc = REXML::Document.new self.xml
    task = REXML::XPath.match(@doc, 'Task').first
    return if task.nil? || task.size.zero?

    info = REXML::XPath.match(task, 'RegistrationInfo').first
    @description = REXML::XPath.match(info, 'Description').first.text
    @uri = REXML::XPath.match(info, 'URI').first.text
    @name = File.basename(@uri).tr('\\', '')

    @actions = []
    execs = REXML::XPath.match(task,'Actions/Exec')
    return if execs.nil? || execs.size.zero?
    execs.each { |exec| @actions << TaskXMLAction.new(exec) }
  end

  def initialize(fname)
    @fname = fname.strip

    raise ArgumentError, 'File name must be provided' if self.fname.nil?
    raise ArgumentError, 'File name cannot be found' unless File.exist?(self.fname)

    self.xml = File.read(@fname).encode!('UTF-8', 'UTF-16', invalid: :replace)
    parse_xml

  end
end
