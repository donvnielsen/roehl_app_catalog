require 'active_record'
require_relative '../../classes/task_xml_file'

# scheduled task
class Task < ActiveRecord::Base
  self.table_name = 'tasks'

  has_many :task_actions, dependent: :delete_all
  has_many :task_servers, dependent: :delete_all

  validates :name, presence: true
  validates :uri, presence: true
  validates :xml, presence: true

  after_initialize :init

  before_save :strip_columns,:downcase_columns

  ERR_INVALID_ID = 'id must reference existing task'

  def init
    self.name ||= ''
    self.uri ||= ''
    self.description ||= ''
    self.xml ||= ''
  end

  def strip_columns
    self.name.strip! unless self.name.nil?
    self.uri.strip! unless self.uri.nil?
    self.description.strip! unless self.description.nil?
  end

  def downcase_columns
  end

  def create_from_filename!(txf)
    unless txf.is_a?(TaskXmlFile)
      raise ArgumentError, 'txf parameter must be an intance of TaskXmlFile'
    end
    self.xml = txf.xml
    self.name = txf.name
    self.uri = txf.uri
    self.description = txf.description
  end
end
