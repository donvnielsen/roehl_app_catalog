require 'standalone_migrations'
require 'ruby-progressbar'
require 'sqlite3'
require 'yaml'
require 'nokogiri'
require 'pp'

ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'
require_relative '../classes/log_formatter/log_server'
require_relative '../classes/build_manager/build_def'
require_relative '../app/models/server'
require_relative '../app/models/roehl_application'
require_relative '../classes/log_formatter/log_roehl_application'
require_relative '../app/models/roehl_application_server'
require_relative '../classes/log_formatter/log_cluster'
require_relative '../app/models/cluster'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
    adapter: CONFIG_DB['adapter'],
    database: File.join(ROOT_DIR, CONFIG_DB['database']),
    # logger: LOGGER
)
LOGGER.level = Logger::DEBUG
LOGGER.info('Applications, Servers, App Server references')

puts "Start #{Time.now}"

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

def propogate_servers(builds)
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
    next if server.nil? || server.size == 0
    if Server.find_by_name(server).nil?
      o = Server.create(name: server)
      LOGGER.debug(LogServer.msg(o,'Created server')) if LOGGER.debug?
    end
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

def propogate_clusters(builds)
  LOGGER.info(__method__.to_s)
  Cluster.destroy_all
  clusters = builds.map {|build| build.app_cluster_name }.uniq

  pb = ProgressBar.create(
      title: __method__.to_s,
      total: clusters.count,
      remainder_mark:'.',
      format: PROGRESS_BAR_OPTIONS[:fmt],
      length: PROGRESS_BAR_OPTIONS[:lg]
  )

  clusters.each {|cluster|
    pb.increment
    next if cluster.nil? || cluster.size == 0
    if Cluster.find_by_name(cluster).nil?
      o = Cluster.create(name: cluster)
      LOGGER.debug(LogCluster.msg(o,'Created cluster')) if LOGGER.debug?
    end
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

def propogate_applications(builds)
  LOGGER.info(__method__.to_s)
  RoehlApplicationServer.destroy_all
  RoehlApplication.destroy_all
  apps = builds.map {|build| {name: build.app_name, folder: build.folder} }.uniq

  pb = ProgressBar.create(
      title: __method__.to_s,
      total: apps.count,
      remainder_mark: '.',
      format: PROGRESS_BAR_OPTIONS[:fmt],
      length: PROGRESS_BAR_OPTIONS[:lg]
  )

  apps.each {|app|
    pb.increment
    next if app.nil? || app[:name] == 0
    RoehlApplication.create(name: app[:name], folder: app[:folder]) if RoehlApplication.find_by_name(app[:name]).nil?
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

def propogate_references(builds)
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
    next if build.app_name.nil? || build.app_name.size == 0
    next if build.server_name.nil? || build.server_name.size == 0

    app = RoehlApplication.find_by_name(build.app_name.downcase)
    server = Server.find_by_name(build.server_name.downcase)
    begin
      RoehlApplicationServer.create( roehl_application_id: app.id, server_id: server.id )
    rescue NoMethodError
      pp build,build.app_name,app,build.server_name,server
      raise
    end
  }
end

LOGGER.info('Begin Applications, Servers, App Server References')

# load builds with nokogiri
builds = nil
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

# propogate_servers(builds)
# propogate_applications(builds)
# propogate_references(builds)
propogate_clusters(builds)

LOGGER.info('End Applications, Servers, App Server References')
