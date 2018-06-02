class BuildClusterTable < ActiveRecord::Migration[5.2]
  def change
    create_table :clusters do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
