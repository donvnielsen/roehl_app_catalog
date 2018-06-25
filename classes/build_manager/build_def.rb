require 'nokogiri'
require 'active_support/core_ext/string/inflections'

class BuildDef
  attr_reader :friendly_name
  attr_reader :target_name
  attr_accessor :properties

  def initialize(o)
    raise ArgumentError, "BuildDef requires an Nokogiri::XML::Element. Recieved class (#{o.class})" unless o.is_a?(Nokogiri::XML::Element)

    init_elements(o)
    parse_friendly_name
    parse_target_name
    parse_properties
  end

  def server_name
    return properties[:server] if properties.has_key?(:server)
    return properties[:vlmrealserverhostname] if properties.has_key?(:vlmrealserverhostname)
    nil
  end

  def app_name
    properties.has_key?(:appname) ? properties[:appname] : nil
  end

  def folder
    properties.has_key?(:webfolder) ? properties[:webfolder] : nil
  end

  def app_cluster_name
    properties.has_key?(:appclustername) ? properties[:appclustername] : nil
  end

  private

  def init_elements(o)
    @elements = {}
    o.children.each {|node|
      @elements[node.name.chomp.downcase.parameterize.underscore.to_sym] = node.text.chomp
    }
  end

  def parse_friendly_name
    @friendly_name = @elements[:targetnamefriendly]
  end

  def parse_target_name
    mtch = /\/t:(?<target>[A-Za-z0-9]*)/.match(@elements[:command])
    raise StandardError,'Builds node must contain /t: to define target' if mtch.nil?
    @target_name = mtch[:target]
  end

  def parse_properties
    @properties = {}
    mtch = /\/property:(?<properties>.*)/.match(@elements[:command])
    unless mtch.nil?
      mtch[:properties].split(';').each {|p|
        k,v = p.split('=')
        @properties[k.downcase.parameterize.underscore.to_sym] = v
      }
    end
  end
end