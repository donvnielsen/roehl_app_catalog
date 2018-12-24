class AddFolderColumnToApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :roehl_applications, :folder, :string
  end
end
