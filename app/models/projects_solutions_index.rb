require 'active_record'

class ProjectSolution < ActiveRecord::Base
  self.table_name = 'projects_solutions'

  belongs_to :solutions
  belongs_to :projects

  validates :solution_id,presence: true
  validates :project_id,presence: true, uniqueness: { scope: :solution_id }

  validate :check_solution_references

  def check_solution_references
    errors.add(:solution_id, Solution::ERR_INVALID_ID) if Solution.find_by_id(self.solution_id).nil?
    errors.add(:project_id, Project::ERR_INVALID_ID) if Project.find_by_id(self.project_id).nil?
  end

end