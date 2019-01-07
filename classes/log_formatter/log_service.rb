require_relative 'log_formatter'

class LogService < LogFormatter
  def self.msg(o,msg)
    o.is_a?(Service) ? msg +
        "\n\t\tService: id(#{LogFormatter.format_id(o.id)})" +
        " name(#{LogFormatter.format_name(o.name).strip})"
        : msg
  end
end
