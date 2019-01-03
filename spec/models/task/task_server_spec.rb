require 'spec_helper'
require_relative '../../../app/models/task_server_index'
require_relative '../../../app/models/task'

describe 'Task Action Server validation' do
  context 'create new task server parameters' do
    before(:all) do
      @errors = TaskServer.create.errors
    end
    it 'will fail if server id is not provided' do
      expect(@errors[:server_id]).to include('id must reference existing server')
    end
    it 'will fail if task id is not provided' do
      expect(@errors[:task_id]).to include('id must reference existing task')
    end
  end

  context 'task/server id not found' do
    before(:all) do
      @errors = TaskServer.create(server_id: 0, task_id: 0).errors
    end
    it 'will fail if server id cannot be found' do
      expect(@errors[:server_id]).to include('id must reference existing server')
    end
    it 'will fail if task id cannot be found' do
      expect(@errors[:task_id]).to include('id must reference existing task')
    end
  end

  context 'task/server id is found' do
    before(:all) do
      @task = Task.create(
          name: 'task/server test task',
          description: 'task/server test task',
          uri: 'uri',
          xml: '<xml></xml>'
      )
      @server = Server.create(name: 'task/server test server', description: 'task/server test server')
    end
    it 'will pass if server id and task id exist' do
      expect{ TaskServer.create(server_id: @server.id, task_id: @task.id) }.to_not raise_exception
    end
  end
end