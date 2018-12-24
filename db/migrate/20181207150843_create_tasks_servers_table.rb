class CreateTasksServersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks_servers do |t|
      t.belongs_to :task
      t.belongs_to :server
    end

    add_index :tasks_servers, [:task_id, :server_id], unique: true,
              name: 'tasks servers unique_index'

    add_foreign_key :tasks, :tasks_servers
    add_foreign_key :servers, :tasks_servers
  end
end
