require_relative '../app/models/solution'
require_relative '../app/models/project'
require_relative '../app/models/projects_solutions_index'
require_relative '../classes/log_formatter/log_solution'
require_relative '../classes/log_formatter/log_project'
require_relative '../classes/csproj_file'

class SolutionFile
  attr_reader :projects, :solution

  class ProjectAttributes
    attr_accessor :sln_guid,:prj_guid,:name,:fname,:id,:type

    def sln_guid=(o)
      @sln_guid = o.nil? ? '' : o.strip.downcase
    end
    def prj_guid=(o)
      @prj_guid = o.nil? ? '' : o.strip.downcase
    end

    def initialize(fname,ovr)
      parse_project(fname) unless fname.nil?
    end

    def parse_project(o)
      lhs,rhs = o.split('=')
      rhs2 = rhs.split(',')

      self.sln_guid = PARSE_GUID.match(lhs.strip).nil? ? '' : ($~)[:guid]
      self.prj_guid = PARSE_GUID.match(rhs2[2].strip).nil? ? '' : ($~)[:guid]
      # @name = PARSE_PROJECT_NAME.match(rhs2[0].strip).nil? ? '' : ($~)[:prjname]
      @name = rhs2[0].strip.gsub(/\A"|"\z/,'')
      # prj.fname = PARSE_CSPROJ_FILENAME.match(rhs2[1].strip).nil? ? '' : ($~)[:csprojname]
      @fname = rhs2[1].strip.gsub!(/^"|"?$/, '')
      @type = File.extname(@fname).downcase.delete('.')
    end
  end

  # extract next project from solution file lines
  def self.next_project!(o)
    raise ArgumentError unless o.kind_of? Array

    ary = []
    while o.size > 0
      e = o.shift
      if ary.size > 0
        ary << e
        return ary if ary.last =~ /^EndProject/
      end
      ary << e if e =~ /^Project\(/
      raise ArgumentError if ary.size > 1 && ary.last =~ /^\S/
    end
    raise ArgumentError if ary.size > 0
    nil
  end

  # extract solution project information from solution file
  def self.parse_projects_from_file(sln_file,ovr=nil)
    unless sln_file.is_a?(Array)
      LOGGER.warn(
          StringIO.open do |s|
            s.puts "Invalid class #{sln_file.class} received by SolutionFile::parse_projects_from_file"
            s.puts "fname ignored: #{@fname}"
            s.string
          end
      )
      return nil
    end if LOGGER.warn?

    projects = []
    until (grp = SolutionFile.next_project!(sln_file)).nil?
      if grp.is_a?(Array) && grp.size > 0
        prj = ProjectAttributes.new(grp.first)
        projects << prj if prj.type == 'csproj'
      end
    end
    projects
  end

  def initialize(fname,ovr=nil)
    @fname = fname
    raise ArgumentError,'fname must be specified' if @fname.nil?
    raise ArgumentError,'file name does not exist' unless File.exist?(@fname)
    @projects = SolutionFile::parse_projects_from_file(
        File.readlines(@fname).map {|l| l.chomp},ovr
    )
  end

  # create projects from solution file
  def create_solution_projects(ovr = nil)
    raise ArgumentError,'projects must be an array' unless @projects.is_a?(Array)
    if @projects.count < 1
      LOGGER.warn("projects array for #{@fname} is empty") if LOGGER.warn?
      return false
    end

    @projects.each {|prj|
      raise ArgumentError unless prj.is_a?(SolutionFile::ProjectAttributes)
      csproj = CsprojFile.new(prj.fname,prj.prj_guid)
      csproj.recurse_projects
      prj.id = o.id
    }
    true
  end

  def create_new_solution_from_file
    name = File.basename(@fname,'.*')
    @solution = Solution.find_by_name(name) ||
        Solution.new(
            name:name,
            guid:@projects.first.sln_guid,
            dir_name:File.dirname(@fname),
            file_name:File.basename(@fname)
        )

    if @solution.new_record?
      unless @solution.valid?
        pp @solution,@fname,File.basename(@fname,'.*'),File.extname(@fname)
        LOGGER.fatal(
            StringIO.open do |s|
              s.puts "Solution #{@solution.name} could not be saved"
              s.puts "fname : #{@fname}"
              s.puts LogSolution.msg(o,'Solution information')
              s.puts @solution.errors
              s.string
            end
        ) if LOGGER.fatal?
        raise ArgumentError, "Solution could not be save [#{@solution.name}]"
      end
      @solution.save!
      LOGGER.debug(LogSolution.msg(@solution,'Solution Information')) if LOGGER.debug?
    end
    @solution
  end

  def relate_projects_to_solutions
    @projects.each {|prj|
      # quitely ignore when duplicate is attempted
      ProjectSolution.create(solution_id:@solution.id, project_id:prj.id)
    }
  end

end
