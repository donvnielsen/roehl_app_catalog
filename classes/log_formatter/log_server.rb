require_relative 'log_formatter'
require_relative '../../app/models/server'

class LogServer < LogFormatter
  def self.msg(o,msg)
    o.is_a?(Server) ? msg +
        "\n\t\tServer: id(#{LogFormatter.format_id(o.id)})" +
        " name(#{LogFormatter.format_name(o.name).strip})"
        : msg
  end
end
