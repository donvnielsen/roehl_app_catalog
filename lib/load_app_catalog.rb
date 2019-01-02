require 'standalone_migrations'
require 'ruby-progressbar'
require 'sqlite3'
require 'yaml'
require 'nokogiri'
require 'pp'

require_relative '../config/environment'
require_relative '../classes/build_manager/build_def'
require_relative '../app/models/server'
require_relative '../app/models/roehl_application'
require_relative '../app/models/roehl_application_server'
require_relative '../app/models/cluster'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(ROOT_DIR, CONFIG_DB['database']),
  :logger => LOGGER
)
LOGGER.level = Logger::DEBUG
LOGGER.info('Applications, Servers, App Server references')

puts "Start #{Time.now}"

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

def populate_servers(builds)
  LOGGER.info(__method__.to_s)
  RoehlApplicationServer.destroy_all
  Server.destroy_all
  servers = builds.map {|build| build.server_name }.uniq

  pb = ProgressBar.create(
    title: __method__.to_s,
    total: servers.count,
    remainder_mark:'.',
    format: PROGRESS_BAR_OPTIONS[:fmt],
    length: PROGRESS_BAR_OPTIONS[:lg]
  )

  servers.each {|server|
    pb.increment
    next if server.nil? || server.size.zero?
    Server.where(name: server.downcase).first_or_create { |o| o.name = server }
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

def populate_clusters(builds)
  LOGGER.info(__method__.to_s)
  Cluster.destroy_all
  clusters = builds.map {|build| build.app_cluster_name }.uniq

  pb = ProgressBar.create(
    title: __method__.to_s,
    total: clusters.count,
    remainder_mark: '.',
    format: PROGRESS_BAR_OPTIONS[:fmt],
    length: PROGRESS_BAR_OPTIONS[:lg]
  )

  clusters.each do |cluster|
    pb.increment
    next if cluster.nil? || cluster.size.zero?
    Cluster.where(name: cluster.downcase).first_or_create { |o| o.name = cluster }
  end

  pb.progress < pb.total ? pb.stop : pb.finish
end

def populate_applications(builds)
  LOGGER.info(__method__.to_s)
  RoehlApplicationServer.destroy_all
  RoehlApplication.destroy_all

  pb = ProgressBar.create(
    title: __method__.to_s,
    total: builds.count,
    remainder_mark: '.',
    format: PROGRESS_BAR_OPTIONS[:fmt],
    length: PROGRESS_BAR_OPTIONS[:lg]
  )

  builds.each do |build|
    pb.increment
    next if build.app_name.nil? || build.app_name.size.zero?
    RoehlApplication.where(name: build.app_name.downcase).first_or_create { |o| o.name = build.app_name }
  end

  pb.progress < pb.total ? pb.stop : pb.finish
end

def populate_application_servers(builds)
  LOGGER.info(__method__.to_s)
  pb = ProgressBar.create(
    title: __method__.to_s,
    total: builds.count,
    remainder_mark: '.',
    format: PROGRESS_BAR_OPTIONS[:fmt],
    length: PROGRESS_BAR_OPTIONS[:lg]
  )

  builds.each { |build|
    pb.increment
    next if build.app_name.nil? || build.app_name.size.zero?
    next if build.server_name.nil? || build.server_name.size.zero?

    app = RoehlApplication.find_by_name(build.app_name.downcase)
    server = Server.find_by_name(build.server_name.downcase)
    begin
      RoehlApplicationServer.create(roehl_application_id: app.id, server_id: server.id)
    rescue NoMethodError
      LOGGER.error(
        "Cannot find server for application(#{build.app_name}) server(#{build.server_name})"
      )
      # pp build, build.app_name, app, build.server_name, server
      # raise
    end
  }
end

LOGGER.info('Begin Applications, Servers, App Server References')

# load builds with nokogiri
builds = nil
fname = File.join(CONFIG['hostname'],CONFIG['buildmanagerdir'], 'BuildManager.xml')
fname = File.join(CONFIG['buildmanagerdir'], 'BuildManager.xml')
File.open(fname) {|f|
  doc = Nokogiri::XML(f) {|config| config.noblanks}
  buildmgr = doc.xpath('xmlns:BuildManagerData')
  begin
    builds = buildmgr.xpath('xmlns:Builds')
  rescue Nokogiri::XML::XPath::SyntaxError
    raise
  end
}

builds = builds.map { |build| BuildDef.new(build) }
puts "# builds: #{builds.count}"

populate_servers(builds)
# inject test server/directories for test purposes
if ['dev','test', 'mintdev'].include?(ENV['RAILS_ENV'])
  unless Server.exists?(name: CONFIG['hostname'])
    Server.create(name: CONFIG['hostname'], description: 'server for dev/test testing')
  end
end

populate_applications(builds)
populate_application_servers(builds)
populate_clusters(builds)

LOGGER.info('End Applications, Servers, App Server References')
