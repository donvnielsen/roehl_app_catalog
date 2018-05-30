require 'spec_helper'
require_relative '../../../app/models/roehl_application_server'
require_relative '../../../app/models/roehl_application'
require_relative '../../../app/models/server'

describe RoehlApplicationServer do

  context 'id presence' do
    before(:all) { DatabaseCleaner.clean }
    it 'should throw errors when ids are not specified' do
      errors = RoehlApplicationServer.create.errors
      expect(errors[:roehl_application_id]).to include("can't be blank")
      expect(errors[:server_id]).to include("can't be blank")
    end
  end

  context 'id presence' do
    before(:all) { DatabaseCleaner.clean }
    it 'should throw error when application is unknown' do
      errors = RoehlApplicationServer.create( roehl_application_id: -1, server_id: -1 ).errors
      expect(errors[:roehl_application_id]).to include(RoehlApplication::ERR_INVALID_ID)
    end
    it 'should throw error when application is known and server is unknown' do
      RoehlApplication.create(name:'application presence')
      errors = RoehlApplicationServer.create(
          roehl_application_id: RoehlApplication.last.id,
          server_id: -1
      ).errors
      expect(errors[:server_id]).to include(Server::ERR_INVALID_ID)
    end
  end

  context 'create application server reference' do
    before(:all) { DatabaseCleaner.clean }
    it 'should create the application server references' do
      app = RoehlApplication.create( name: 'application presence' )
      server = Server.create( name: 'application presence' )
      RoehlApplicationServer.create(roehl_application_id: app.id, server_id: server.id)
      expect(RoehlApplicationServer.last.roehl_application_id).to eq(app.id)
      expect(RoehlApplicationServer.last.server_id).to eq(server.id)
    end
  end

end