require 'nokogiri'

class TaskXMLAction
  attr_reader :exec, :command, :arguments

  def initialize(exec)
    @exec = exec
    parse_xml_exec
  end

  private

  def parse_xml_exec
    cmd = @exec.xpath('xmlns:Command')
    @command = cmd.empty? ? '' : cmd.first.content
    args = @exec.xpath('xmlns:Arguments')
    @arguments = args.empty? ? '' : args.first.content
    self
  end
end