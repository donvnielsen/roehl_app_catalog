require 'active_record'

class ProjectProject < ActiveRecord::Base
  self.table_name = 'projects_projects'

  belongs_to :project

  validates :project_id,presence: true
  validates :project_ref_id,presence: true, uniqueness: { scope: :project_id }

  validate :check_project_references

  def check_project_references
    errors.add(:project_id, Project::ERR_INVALID_ID) if Project.find_by_id(self.project_id).nil?
    errors.add(:project_ref_id, Project::ERR_INVALID_ID) if Project.find_by_id(self.project_ref_id).nil?
  end
end