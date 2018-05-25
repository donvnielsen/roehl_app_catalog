require_relative 'classes/solution_file'
require_relative 'app/models/solution'
require_relative 'app/models/project'

require 'ruby-progressbar'
require 'sqlite3'
require 'pp'

# ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database  => File.join(Dir.getwd,'db','dev.db')
)
solutions_dir = File.join(Dir.getwd,'spec','data','dockhours','**','rti*.sln')
solution_files = Dir.glob(solutions_dir, File::FNM_CASEFOLD)
puts solutions_dir
puts "Solution Files: #{solution_files.count}"

ActiveRecord::Migrator.migrate(File.join(Dir.getwd, 'db', 'migrate'))

Solution.delete_all
Project.delete_all
SolutionProjectIndex.delete_all

pb = ProgressBar.create(
    title:'Solutions',
    total:solution_files.count,
    remainder_mark:'.',
    format:'%t |%B| %c of %C %p%%',
    length: 80
)

solution_files.sort.each {|fname|
  pb.increment
  # break if pb.progress > 50
  solution = Solution.create_from_filename!(fname)
  if solution.nil?
    puts fname
  else
    # next unless solution.name == 'RTI.Alerts.Complete'
    SolutionFile.new(fname,solution.id) unless ['RTIWebApp'].include?(solution.name)
  end

}
pb.progress < pb.total ? pb.stop : pb.finish
