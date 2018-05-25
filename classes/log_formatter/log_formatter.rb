require 'logger'

class LogFormatter < Logger::Formatter
  def self.NA_when_empty(o)
    o.to_s.empty? ? 'n/a' : o
  end

  def self.format_id(o,lg=5)
    if o.to_s.strip.empty?
      "%-#{lg}s" % LogFormatter.NA_when_empty(nil)
    else
      if o.is_a?(Fixnum)
        s = "%0#{lg}d" % o.to_s.strip.to_i
      else
        s = o.to_s.strip
      end
      "%-#{lg}s" % s[s.size > lg ? s.size-lg : 0,lg]
    end
  end

  def self.format_guid(o,lg=38)
    format_string(o,lg)
  end

  def self.format_name(o,lg=30)
    format_string(o,lg)
  end

  def call(severity, time, progname, msg)
    "#{time} - #{msg2str(msg)}"
    # formatted_severity = sprintf("%-5s",severity.to_s)
    # formatted_time = time.strftime("%Y-%m-%d %H:%M:%S")
    # "[#{formatted_severity} #{formatted_time} #{$$}]\n #{msg}\n"
  end

  private

  def self.format_string(o,lg)
    o.to_s.strip.empty? ? LogFormatter.NA_when_empty(nil) : "%-#{lg}s" % o.to_s[0,lg]
  end
end