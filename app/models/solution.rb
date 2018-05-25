require 'active_record'

# if name is empty, attempt to extract if from solution file

class Solution < ActiveRecord::Base
  serialize :sln_file

  # has_many :projects_solutions, dependent: destroy

  after_initialize :init
  before_validation :load_solution_file

  # validates :name,presence: true,uniqueness: { case_sensitive: false }
  validates :file_name,presence: true
  validates :dir_name,presence: true
  validates :guid,presence: true
  validates :name,presence: true, uniqueness: {case_sensitive: false}

  before_save :strip_columns,:downcase_columns

  ERR_INVALID_ID = 'id must reference existing solution'

  def init
    self.dir_name ||= ''
    self.file_name ||= ''
    self.name ||= ''
    self.guid ||= ''
    self.sln_file ||= []
  end

  def strip_columns
    self.guid.strip! unless self.guid.nil?
    self.name.strip! unless self.name.nil?
    self.file_name.strip! unless self.file_name.nil?
    self.dir_name.strip! unless self.dir_name.nil?
  end

  def downcase_columns
    self.guid.downcase! unless self.guid.nil?
  end

  def load_solution_file
    fname = File.join(self.dir_name,self.file_name)
    self.sln_file = File.file?(fname) && File.exist?(fname) ?
                        File.readlines(fname).map {|ln| ln.chomp} : []
  end

  def self.create_from_filename!(fname)
    fname = File.expand_path(fname.strip)
    return nil if File.directory?(fname)
    return nil unless File.extname(fname) == '.sln'
    return nil unless File.exist?(fname)

    Solution.create!(
        dir_name: File.dirname(fname),
        file_name: File.basename(fname),
        guid: '?',
        name: File.basename(fname,'.*'),
    )

  end

end