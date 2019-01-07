class CreateServicesServersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :services_servers do |t|
      t.belongs_to :service
      t.belongs_to :server
    end

    add_index :services_servers, [:service_id, :server_id], unique: true,
              name: 'services servers unique_index'

    add_foreign_key :services, :services_servers
    add_foreign_key :servers, :services_servers
  end
end
