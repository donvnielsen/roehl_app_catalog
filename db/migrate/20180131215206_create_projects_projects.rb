class CreateProjectsProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects_projects do |t|
      t.integer :project_id
      t.integer :project_ref_id
    end

    add_index :projects_projects, [:project_id, :project_ref_id], unique: true,
              name: 'projects_projects_unique_index'

    add_foreign_key :projects, :project_references
    add_foreign_key :projects, :project_references
  end

end
