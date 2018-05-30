class RoehlApplicationsServers < ActiveRecord::Migration[5.2]
  def change
    create_table :roehl_applications_servers do |t|
      t.belongs_to :roehl_application
      t.belongs_to :server
    end

    add_index :roehl_applications_servers, [:roehl_application_id, :server_id], unique: true,
              name: 'roehl_applications_servers_unique_index'

    add_foreign_key :roehl_applications, :roehl_applications_servers
    add_foreign_key :servers, :roehl_applications_servers
  end
end
