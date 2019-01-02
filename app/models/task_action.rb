require 'active_record'

# Task actions associated with a task
class TaskAction < ActiveRecord::Base
  self.table_name = 'tasks_actions'

  belongs_to :task

  validates :task_id, presence: true
  validates :command, presence: true
  validates :folder, presence: true
  validates :executable, presence: true

  after_initialize :init

  before_save :strip_columns

  ERR_INVALID_ID = 'id must reference existing task'
  PARSE_CMD_LINE_STRING = /^(?:"([^"]+(?="))|([^\s]+))["]{0,1} *(.+)?$/

  def init
    self.command ||= ''
    self.folder ||= ''
    self.executable ||= ''
    self.parameters ||= ''

    unless self.command.empty?
      self.folder = File.dirname(command) if self.folder.empty?
      self.executable = File.basename(command) if self.executable.empty?
    end
  end

  def strip_columns
    self.command.strip! unless self.command.nil?
    self.folder.strip! unless self.folder.nil?
    self.executable.strip! unless self.executable.nil?
  end

end

