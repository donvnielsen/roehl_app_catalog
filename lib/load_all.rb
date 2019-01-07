require 'standalone_migrations'
require_relative '../config/environment'

ENV['RAILS_ENV'] = 'test'

dbname = File.join(ROOT_DIR, CONFIG_DB['database'])
puts "writing to db '#{dbname}'"

ActiveRecord::Base.establish_connection(
  adapter: CONFIG_DB['adapter'],
  database: dbname,
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
system 'ruby -S load_services.rb'
LOGGER.info('load_services complete')

LOGGER.info('load_all end')
