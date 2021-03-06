require 'active_record'
require 'action_view'
require 'standalone_migrations'
require 'sqlite3'
require 'stringio'
require 'database_cleaner'
require 'os'
require 'pp'

ENV['RAILS_ENV'] = 'dev'

require_relative '../config/environment'

SPEC_DATA_DIR = if OS.posix?
                  '/home/dvn/Documents/roehl_app_catalog_test_data'
                else
                  'c:/users/niedo/Documents/roehl_app_catalog_test_data'
                end
TEST_SOLUTION_FILE = File.join(SPEC_DATA_DIR, 'spec_test_solution.sln')
TEST_PROJECT_FILE  = File.join(SPEC_DATA_DIR, 'spec_test_project.csproj')
TEST_TASK_FILE = File.join(SPEC_DATA_DIR, 'services_and_tasks', 'tasks', 'RTIViaPointVerification.xml')

# SPEC_LOG_FILE = File.join(SPEC_DIR, 'logs', 'test.log')
SPEC_LOG_FILE = StringIO.new
SPEC_LOGGER = Logger.new(SPEC_LOG_FILE)
SPEC_LOGGER.level = Logger::WARN
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(ROOT_DIR, CONFIG_DB['database']),
  log: SPEC_LOGGER
)

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :truncation

