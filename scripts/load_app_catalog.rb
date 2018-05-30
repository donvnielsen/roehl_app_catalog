require 'standalone_migrations'
require 'ruby-progressbar'
require 'sqlite3'
require 'yaml'
require 'nokogiri'
require 'pp'

ENV['RAILS_ENV'] = 'dev'

require_relative '../config/environment'
require_relative '../classes/log_formatter/log_server'
require_relative '../classes/build_manager/build_def'
require_relative '../app/models/server'
require_relative '../app/models/roehl_application'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.join(ROOT_DIR, CONFIG_DB['database'])
)

puts "Start #{Time.now}"

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

def propogate_servers(builds)
  pb = ProgressBar.create(
      title: __method__.to_s,
      total: builds.count,
      remainder_mark:'.',
      format: '%t |%B| %c of %C %p%%',
      length: 80
  )

  servers = builds.map {|build|
    pb.increment
    BuildDef.new(build).server_name
  }.uniq
  servers.each {|server|
    Server.find_by_name(server) || Server.create(name: server)
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

def propogate_applications(builds)
  pb = ProgressBar.create(
      title: __method__.to_s,
      total: builds.count,
      remainder_mark: '.',
      format: '%t |%B| %c of %C %p%%',
      length: 80
  )

  apps = builds.map {|build|
    pb.increment
    BuildDef.new(build).app_name
  }.uniq
  apps.each {|app|
    RoehlApplication.find_by_name(app) || RoehlApplication.create(name: app)
  }

  pb.progress < pb.total ? pb.stop : pb.finish
end

Server.destroy_all
RoehlApplication.destroy_all

# load builds with nokogiri
builds = nil
File.open(File.join(
    '/home',
    'dvn',
          'Documents',
          'roehl_app_catalog_test_data',
          'build_manager',
          'BuildManager.xml'
  )
) {|f|
  doc = Nokogiri::XML(f) {|config| config.noblanks}
  buildmgr = doc.xpath('xmlns:BuildManagerData')
  begin
    builds = buildmgr.xpath('xmlns:Builds')
  rescue Nokogiri::XML::XPath::SyntaxError
    raise
  end
}

propogate_servers(builds)
propogate_applications(builds)

puts "End #{Time.now}"
