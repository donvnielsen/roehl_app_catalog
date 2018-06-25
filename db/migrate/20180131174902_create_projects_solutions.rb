class CreateProjectsSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :projects_solutions do |t|
      t.belongs_to :solution
      t.belongs_to :project
    end

    add_index :projects_solutions, [:solution_id, :project_id], unique: true,
              name: 'projects_solutions_unique_index'

    add_foreign_key :solutions, :projects_solutions
    add_foreign_key :projects, :projects_solutions
  end
end
