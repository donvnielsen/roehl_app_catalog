class CreateTasksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :uri
      t.string :description
      t.string :xml, limit: 1.megabytes
      t.timestamps
    end
  end
end
