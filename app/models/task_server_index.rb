require 'active_record'

# Links a task to the server it runs on
class TaskServer < ActiveRecord::Base
  self.table_name = 'tasks_servers'

  belongs_to :tasks
  belongs_to :servers

  validates :task_id,presence: true
  validates :server_id,presence: true, uniqueness: { scope: :task_id }

  validate :check_task_references

  def check_task_references
    errors.add(:task_id, Task::ERR_INVALID_ID) if Task.find_by_id(self.task_id).nil?
    errors.add(:server_id, Server::ERR_INVALID_ID) if Server.find_by_id(self.server_id).nil?
  end

end
