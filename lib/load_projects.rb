require 'standalone_migrations'
require 'ruby-progressbar'
require 'sqlite3'
require 'yaml'
require 'pp'

ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'
require_relative '../classes/csproj_file'
require_relative '../classes/log_formatter/log_solution'
require_relative '../classes/log_formatter/log_project'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database  => File.join(ROOT_DIR, CONFIG_DB['database']),
    :logger => LOGGER
)

LOGGER.info("Begin load_projects, qty = #{Project.count}")

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

pb = ProgressBar.create(
    title: 'Projects',
    total: Project.count,
    remainder_mark: '.',
    format: PROGRESS_BAR_OPTIONS[:fmt],
    length: PROGRESS_BAR_OPTIONS[:lg]
)

Project.all.each {|prj|
  pb.increment
  next unless prj[:ptype] == 'csproj'
  fname = File.join(CONFIG['datadir'],'dockhours','projects',"#{prj[:name]}.csproj")
  LOGGER.debug(LogProject.msg(prj,'Solution Project')) if LOGGER.debug?
  csproj = CsprojFile.new( fname,prj[:guid],0 )
  csproj.recurse_projects( File.join(CONFIG['datadir'],'projects') )
} if Project.count > 0

pb.progress < pb.total ? pb.stop : pb.finish

LOGGER.info("End load_projects, projects = #{Project.count}")
