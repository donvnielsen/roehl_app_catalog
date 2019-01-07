require 'rexml/document'

class ServiceXmlFile
  attr_reader :fname, :xml, :name, :displayname, :pathname, :description

  def initialize(fname)
    @fname = fname.strip unless fname.nil?

    raise ArgumentError, 'File name must be provided' if self.fname.nil? or self.fname.empty?
    raise ArgumentError, 'File name cannot be found' unless File.exist?(self.fname)

    @xml = File.read(@fname).encode!('UTF-8', 'UTF-16', invalid: :replace)
    parse_xml

  end

  private

  def parse_xml
    @doc = REXML::Document.new self.xml
    props = REXML::XPath.match(@doc, 'Objs/Obj/Props').first
    return if props.nil? || props.size.zero?

    @name = get_property(props,'Name')
    @displayname = get_property(props,'DisplayName')
    @pathname = get_property(props,'PathName')
    @description = get_property(props,'Description')
  end

  def get_property(props,attr)
    (p = props.elements["S[@N='#{attr}']"]).nil? ? '' : p.text
  end
end