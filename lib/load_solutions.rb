require 'standalone_migrations'
require 'ruby-progressbar'
require 'sqlite3'
require 'yaml'
require 'database_cleaner'
require 'pp'

ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'
require_relative '../classes/solution_file'
require_relative '../classes/log_formatter/log_solution'
require_relative '../classes/log_formatter/log_project'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database  => File.join(ROOT_DIR, CONFIG_DB['database']),
    :logger => LOGGER
)
LOGGER.level = Logger::INFO
LOGGER.info('Migrations')

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

LOGGER.info('cleaning database')
DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

solutions_dir = File.join(ROOT_DIR, CONFIG['datadir'], 'solutions', '*.sln')
# solutions_dir = File.join(ROOT_DIR, CONFIG['datadir'], 'solutions', 'RTI*.sln')
# solutions_dir = File.join(ROOT_DIR, CONFIG['datadir'], 'solutions', 'a*.sln')
solution_files = Dir.glob(solutions_dir, File::FNM_CASEFOLD).sort
puts solutions_dir
puts "Solution Files: #{solution_files.count}"
LOGGER.info("solutions folder #{solutions_dir}")
LOGGER.info("load_solutions start. # solutions = #{solution_files.count}")

pb = ProgressBar.create(
    title:'Solutions',
    total:solution_files.count,
    remainder_mark:'.',
    format:'%t |%B| %c of %C %p%%',
    length: 80
)

solution_files.each {|fname|
  pb.increment
  # next if ['RTIWebApp'].include?(fname)
  # next unless fname.include?('MileMaker')
  LOGGER.debug(fname) if LOGGER.debug?
  ActiveRecord::Base.transaction do
    sf = SolutionFile.new(fname)
    unless sf.nil?
      begin
        if sf.create_solution_projects(File.join(SPEC_DIR,'data','dockhours','projects'))
          sf.create_new_solution_from_file
          LOGGER.debug(LogSolution.msg(sf.solution,'Completed solution')) if LOGGER.debug?
          sf.relate_projects_to_solutions
        end
      rescue
        puts "\nAbend #{Time.now}"
        msg = "unknown error processing solution ##{pb.progress}\n#{fname}"
        LOGGER.fatal(msg)
        puts "\n#{msg}"
        pp sf
        raise
        break
      end
    end
  end
  # break if pb.progress > 10
}

pb.progress < pb.total ? pb.stop : pb.finish
LOGGER.info('load_solutions finish')
