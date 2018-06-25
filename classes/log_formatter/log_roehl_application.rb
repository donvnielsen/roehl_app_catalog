require_relative 'log_formatter'
require_relative '../../app/models/roehl_application'

class LogRoehlApplication < LogFormatter
  def self.msg(o,msg)
    o.is_a?(RoehlApplication) ? msg +
        "\n\t\tApplication: id(#{LogFormatter.format_id(o.id)})" +
        " name(#{LogFormatter.format_name(o.name).strip})"
        : msg
  end
end
