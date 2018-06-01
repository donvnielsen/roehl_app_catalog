class AddApplicationType < ActiveRecord::Migration[5.2]
  def change
    add_column :roehl_applications, :type, :integer

    add_foreign_key :roehl_applications, :application_servers
  end
end
