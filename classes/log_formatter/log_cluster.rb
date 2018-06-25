require_relative 'log_formatter'
require_relative '../../app/models/cluster'

class LogCluster < LogFormatter
  def self.msg(o,msg)
    o.is_a?(Cluster) ? msg +
        "\n\t\tServer: id(#{LogFormatter.format_id(o.id)})" +
        " name(#{LogFormatter.format_name(o.name).strip})"
        : msg
  end
end
