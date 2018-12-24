class CreateTasksActionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks_actions do |t|
      t.belongs_to :task

      t.string :command
      t.string :folder
      t.string :executable
      t.string :parameters
    end

    add_foreign_key :tasks, :tasks_actions
  end

end
