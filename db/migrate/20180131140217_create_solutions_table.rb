class CreateSolutionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :solutions do |t|
      t.string :guid
      t.string :name, unique:true
      t.string :file_name
      t.string :dir_name
      t.binary :sln_file, limit:1.megabytes
      t.timestamps
    end

  end

end
