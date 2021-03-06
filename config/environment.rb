require 'logger'
require 'yaml'

ENV['RAILS_ENV'] = 'mintdev'

ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__),'..'))
CONFIG_DIR = File.expand_path(File.join(ROOT_DIR,'config'))
SPEC_DIR = File.expand_path(File.join(ROOT_DIR,'spec'))
LOG_DIR = File.expand_path(File.join(ROOT_DIR,'logs'))

CONFIG = YAML::load(File.open(File.join(CONFIG_DIR,'config.yml')))[ENV['RAILS_ENV']]
CONFIG_DB = YAML::load(File.open(File.join(CONFIG_DIR,'config_db.yml')))[ENV['RAILS_ENV']]

LOGGER_FILE = File.join(LOG_DIR,"#{Time.now.strftime('%Y%m%d_%H%M%S')}.log")
LOGGER = Logger.new(LOGGER_FILE)
LOGGER.level = Logger::DEBUG  #,INFO,WARN,ERROR,FATAL,UNKNOWN
# LOGGER.progname = 'testing' or LOGGER.info 'pgm' {'message'}
LOGGER.datetime_format = "%Y-%m-%d %H:%M:%S"
PROGRESS_BAR_OPTIONS = {fmt: '%t |%B| %c of %C %p%%', lg: 80}

# StringIO.open do |s|
#   s.puts
#   s.puts 'and simple'
#   s.string
# end

PARSE_GUID = /[{(]?(?<guid>[0-9A-F]{8}[-]?([0-9A-F]{4}[-]?){3}[0-9A-F]{12})[)}]?/
PARSE_CSPROJ_FILENAME = /\"(?<csprojname>((?:[^\/]*\/)*)([A-Za-z0-9_]+\.csproj))\"/
PARSE_PROJECT_NAME = /\"(?<prjname>[A-Za-z0-9._-]+)\"/
PARSE_CMD_LINE_STRING = /^(?:"([^"]+(?="))|([^\s]+))["]{0,1} *(.+)?$/
