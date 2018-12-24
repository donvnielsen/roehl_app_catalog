class CreateProjectsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :guid, unique:true
      t.string :name, unique:true
      t.string :dir_name
      t.string :file_name
      t.string :ptype
      t.binary :csproj_file, limit:1.megabyte

      t.timestamps
    end

  end
end
