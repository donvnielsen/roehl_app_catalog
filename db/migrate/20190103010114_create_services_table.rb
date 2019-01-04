class CreateServicesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.string :pathname
      t.string :description
      t.string :xml, limit: 1.megabytes

      t.timestamps
    end
  end
end
