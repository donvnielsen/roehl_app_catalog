require 'stringio'

f = StringIO.new
f.write 'this'
f.write 'that'
f.rewind
puts f.read



__END__
ENV['RAILS_ENV'] = 'dev'

require 'pp'
require_relative '../config/environment'
require_relative '../app/models/solution'
require_relative '../classes/log_formatter/log_solution'

ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database  => File.join(ROOT_DIR, CONFIG_DB['database'])
)

LOGGER.progname = 'testing'
# LOGGER.debug "debugging info"
# LOGGER.info "general logs"
# LOGGER.warn "oh my…this isn't good"
# LOGGER.error "boom!"
# LOGGER.fatal "oh crap…"

sln = Solution.new(id:1,guid:'guid',name:'xyz')
LOGGER.info LogSolution.msg(sln,'this is a test')
pp LOGGER
pp LOGGER.logdev

