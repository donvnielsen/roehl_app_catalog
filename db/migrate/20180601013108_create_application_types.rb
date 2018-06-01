require_relative '../../app/models/application_type'

class CreateApplicationTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :application_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    ApplicationType.create(name: 'ApplicationType')
    ApplicationType.create(name: 'Access')
    ApplicationType.create(name: 'DeploymentPlaceHolder')
    ApplicationType.create(name: 'FullyOutsourced')
    ApplicationType.create(name: 'PublicWebApp')
    ApplicationType.create(name: 'ScheduledTask')
    ApplicationType.create(name: 'WCFService')
    ApplicationType.create(name: 'WebApp')
    ApplicationType.create(name: 'WebService')
    ApplicationType.create(name: 'WindowsApp')
    ApplicationType.create(name: 'WindowsService')

  end
end
