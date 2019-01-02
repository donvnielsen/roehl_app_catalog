require 'standalone_migrations'
require_relative '../config/environment'

ActiveRecord::Base.establish_connection(
  adapter: CONFIG_DB['adapter'],
  database: File.join(ROOT_DIR, CONFIG_DB['database']),
  logger: LOGGER
)
LOGGER.level = Logger::DEBUG
LOGGER.info('load_all begin')

puts "Start Loading All #{Time.now}"

migration_db = File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate')
LOGGER.info("Migrations folder : #{migration_db}")
ActiveRecord::Migration.migrate(migration_db)

system 'ruby -S load_app_catalog.rb'
LOGGER.info('load_app_catalog complete')
system 'ruby -S load_solutions.rb'
LOGGER.info('load_solutions complete')
system 'ruby -S load_projects.rb'
LOGGER.info('load_projects complete')
system 'ruby -S load_tasks.rb'
LOGGER.info('load_tasks complete')

LOGGER.info('load_all end')
