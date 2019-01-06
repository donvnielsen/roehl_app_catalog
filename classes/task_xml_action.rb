require 'rexml/document'

class TaskXMLAction
  attr_reader :exec, :command, :arguments

  def initialize(exec)
    @exec = exec
    parse_xml_exec
  end

  private

  def parse_xml_exec
    cmd = REXML::XPath.match(@exec, 'Command')
    @command = cmd.empty? ? '' : cmd.first.text
    args = REXML::XPath.match(@exec, 'Arguments')
    @arguments = args.empty? ? '' : args.first.text
    self
  end
end