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
require_relative '../app/models/roehl_application_server'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(ROOT_DIR, CONFIG_DB['database'])
)

puts "Start #{Time.now}"

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

def propogate_servers(builds)
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
    Server.create(name: server) if Server.find_by_name(server).nil?
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

def propogate_applications(builds)
  RoehlApplication.destroy_all
  apps = builds.map {|build| build.app_name }.uniq

  pb = ProgressBar.create(
      title: __method__.to_s,
      total: apps.count,
      remainder_mark: '.',
      format: PROGRESS_BAR_OPTIONS[:fmt],
      length: PROGRESS_BAR_OPTIONS[:lg]
  )

  apps.each {|app|
    pb.increment
    next if app.nil? || app.size == 0
    RoehlApplication.create(name: app) if RoehlApplication.find_by_name(app).nil?
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

def propogate_references(builds)
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

# load builds with nokogiri
builds = nil
fname = File.join(CONFIG['datadir'], 'build_manager', 'BuildManager.xml')
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

RoehlApplicationServer.destroy_all

propogate_servers(builds)
propogate_applications(builds)
propogate_references(builds)

puts "End #{Time.now}"
