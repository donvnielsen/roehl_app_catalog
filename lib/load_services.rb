require 'standalone_migrations'
require 'ruby-progressbar'
require 'sqlite3'
require 'yaml'
require 'pp'

require_relative '../config/environment'
require_relative '../classes/log_formatter/log_service'
require_relative '../app/models/server'
require_relative '../app/models/service'
require_relative '../app/models/service_server_index'
require_relative '../classes/service_xml_file'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
    adapter: CONFIG_DB['adapter'],
    database: File.join(ROOT_DIR, CONFIG_DB['database']),
    logger: LOGGER
)
LOGGER.level = Logger::DEBUG
LOGGER.info('Services')

puts "Start #{Time.now}"

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

# for each task, create entry and parse actions
def populate_service(server, services)
  server_services = Dir.glob(File.join(services,'*.xml'))
  return if server_services.nil? || server_services.empty?
  LOGGER.info("Server #{server.name} tasks #{server_services.count}")

  pb = ProgressBar.create(
      title: 'Services',
      total: server_services.count,
      remainder_mark: '.',
      format: PROGRESS_BAR_OPTIONS[:fmt],
      length: PROGRESS_BAR_OPTIONS[:lg]
  )

  server_services.each do |entry|
    pb.increment
    service_xml = ServiceXmlFile.new(entry)
    service = Service.create(
        name: service_xml.name,
        displayname: service_xml.displayname,
        pathname: service_xml.pathname,
        description: service_xml.description,
        xml: service_xml.xml
    )

    ServiceServer.create!(service_id: service.id, server_id: server.id)
  end

  pb.progress < pb.total ? pb.stop : pb.finish
end

Service.destroy_all
ServiceServer.destroy_all

# look for tasks folders in each server. if found, then process
# each xml file in that folder, ensuring it is for a task.
Server.all.each do |server|

  next unless ['dev','test','mintdev'].include?(ENV['RAILS_ENV']) && server.name.include?('pc1932')

  services_dir = File.join('//',server.name, CONFIG['servicessubdir'])
  populate_service(server, services_dir) if Dir.exist?(services_dir)
end

LOGGER.info("End load_services, services = #{Service.count}")
