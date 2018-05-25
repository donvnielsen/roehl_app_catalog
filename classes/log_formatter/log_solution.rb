require_relative 'log_formatter'
require_relative '../../app/models/solution'

class LogSolution < LogFormatter
  def self.msg(o,msg)
    o.is_a?(Solution) ? msg +
      "\n\tSolution: id(#{LogFormatter.format_id(o.id)})" +
      " name(#{LogFormatter.format_name(o.name).strip})" +
      " guid(#{LogFormatter.format_guid(o.guid).strip})"
      : msg
  end
end
