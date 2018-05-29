require 'ruby-progressbar'
require 'nokogiri'

require_relative '../app/models/solution'
require_relative '../app/models/project'
require_relative '../app/models/project_project_index'

class CsprojFile
  attr_reader :idx, :guid, :fname, :ref_projects, :prj

  def self.parse_project_reference(ref)
    raise ArgumentError unless ref.is_a?(Nokogiri::XML::Element)
    rc = {file_name:ref['Include'].gsub('\\','/')}
    ref.element_children.each {|child|
      rc[:guid] = child.text.match(/\{(?<guid>.*)\}/)[:guid].downcase if child.name == "Project"
      rc[:name] = child.text if child.name == "Name"
    }
    rc
  end

  def indent(chr=' ')
    sprintf('%3d. '+ chr*(@idx-1)*2,@idx)
  end

  def initialize(fname,guid,index=0)
    raise ArgumentError,'File name must be provided' if fname.nil?
    raise ArgumentError,'Guid must be provided' if guid.nil?
    raise ArgumentError,'Index must be not nil and 0 or greater' if index.nil? || index < 0
    @fname = fname
    @guid = guid
    @idx = index + 1

    # create new project in the db if it does not already
    @prj = Project.find_by_guid(guid)
    if @prj.nil?
      @prj = Project.create( guid:guid, file_name:fname )
    else
      # set the csproj_file when it is nil. this could happen if a prior project
      # reference did not contain a file specification for the csproj file.
      if @prj.csproj_file.nil?
        @prj.file_name = fname
        @prj.save!
      end
    end

    load_projects
  end

  # load the specified csproj file
  def load_projects
    # raise ArgumentError, "Bad file name #{self.fname}" unless File.exist?(self.fname)
    @ref_projects = []
    if File.exist?(self.fname)
      File.open(self.fname) {|f|
        doc = Nokogiri::XML(f) {|config| config.noblanks}
        begin
          prj = doc.xpath('xmlns:Project')
        rescue Nokogiri::XML::XPath::SyntaxError
          return
        end
        groups = prj.xpath('xmlns:ItemGroup')
        groups.each_with_index {|g,i|
          projectreferences = g.xpath('xmlns:ProjectReference')
          unless projectreferences.nil? || projectreferences.count == 0
            projectreferences.each {|prjref|
              @ref_projects << CsprojFile.parse_project_reference(prjref)
            }
          end
        }
      }
    end
    @ref_projects

  end

  # when the number of project references is greater than zero,
  # the recurse each one...looking into their project references.
  # eventually you reach projects that have no project references.
  # @param ovr string directory name override
  def recurse_projects(ovr=nil)
    if @ref_projects.size > 0
      @ref_projects.count.times {|i|
        prj = @ref_projects.shift

        # this reference does not have to be recursed; it already has been.
        # but a project reference does need to be created linking the
        # current project to this reference.
        if (p=Project.find_by_guid(prj[:guid]))
          if (pp = ProjectProject.find_by_project_id(p.nil? ? -1 : p.id))
            ProjectProject.create(project_id:self.prj.id, project_ref_id:pp.project_id)
            LOGGER.debug(indent + prj[:name] + ' already logged') if LOGGER.debug?
            next
          end
        end
        LOGGER.debug(indent + prj[:name]) if LOGGER.debug?

        # replace the projects directory name with the override directory when specified
        fname = ovr.nil? ? prj[:file_name] : File.join(ovr, File.basename(prj[:file_name]))

        csproj = CsprojFile.new(fname, prj[:guid], @idx)
        csproj.recurse_projects(ovr)

        # when returning from a recursion, create a reference from this
        # project to the referenced project. It is a quiet create, meaning
        # an exception is not thrown if the reference already exists
        begin
          ProjectProject.create(project_id:self.prj.id, project_ref_id:csproj.prj.id)
        rescue NoMethodError
          pp "\n",fname,csproj.prj,self.prj
          raise
        end
      }
    end
  end
end