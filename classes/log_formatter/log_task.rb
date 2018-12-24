require_relative 'log_formatter'
require_relative '../../app/models/task_action'

class LogTask < LogFormatter
  def self.msg(o,msg)
    o.is_a?(Task) ? msg +
        "\n\t\tTask: id(#{LogFormatter.format_id(o.id)})" +
        " name(#{LogFormatter.format_name(o.name).strip})"
        : msg
  end
end
