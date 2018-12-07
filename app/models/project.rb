require 'active_record'

class Project < ActiveRecord::Base
  serialize :csproj_file

  has_many :project_solution, dependent: :destroy

  validates :name,presence: true
  validates :guid,presence: true, uniqueness: {case_sensitive: false}

  after_initialize :init

  before_validation :strip_columns, :downcase_columns
  before_validation :cleanse_file_names,:cleanse_ptype

  ERR_INVALID_ID = 'id must reference existing project'

  def file_name=(o)
    super(o)
    init
    load_csproj_file unless o.nil? || !self.csproj_file.nil?
    @file_name = File.basename(self.file_name)
  end

  def init
    self.dir_name ||= File.dirname(self.file_name)
    self.ptype ||= File.extname(self.file_name).delete('.')
    self.name ||= File.basename(self.file_name,'.*')
  end

  def downcase_columns
    self.guid.downcase! unless self.guid.nil?
    self.ptype.downcase! unless self.ptype.nil?
  end

  def strip_columns
    self.guid.strip! unless self.guid.nil?
    self.name.strip! unless self.name.nil?
    self.file_name.strip! unless self.file_name.nil?
    self.ptype.strip! unless self.ptype.nil?
  end

  def cleanse_file_names
    self.file_name.gsub!('\\','/') unless self.file_name.nil?
    self.dir_name.gsub!('\\','/') unless self.dir_name.nil?
  end

  def cleanse_ptype
    self.ptype.delete!('.') unless self.ptype.nil?
  end

  private

  def load_csproj_file
    unless self.file_name.nil?
      self.csproj_file = File.file?(self.file_name) && File.exist?(self.file_name) ?
                             File.readlines(self.file_name) : nil
    end
  end

end