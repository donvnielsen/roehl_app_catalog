require 'spec_helper'
require_relative '../../../app/models/task_action'

describe 'task_action' do
  context 'create empty action' do
    it 'will fail because of validations' do
      expect(TaskAction.create.valid?).to be_falsey
    end

    context 'will identify empty attributes' do
      before(:all) do
        @errors = TaskAction.create.errors
      end

      it 'will require a task id' do
        expect(@errors[:task_id]).to include("can't be blank")
      end
      it 'will require a command' do
        expect(@errors[:command]).to include("can't be blank")
      end
      it 'will require a folder' do
        expect(@errors[:folder]).to include("can't be blank")
      end
      it 'will require an executable' do
        expect(@errors[:executable]).to include("can't be blank")
      end
    end
  end

  context 'accept values' do
    before(:all) do
      @action = TaskAction.create(
        task_id: 1,
        command: 'folder/exe -x',
        folder: 'folder',
        executable: 'executable',
        parameters: 'parameters'
      )
    end
    it 'will accept a task id' do
      expect(@action.task_id).to eq(1)
    end
    it 'will accept a command' do
      expect(@action.command).to eq('folder/exe -x')
    end
    it 'will accept a folder' do
      expect(@action.folder).to eq('folder')
    end
    it 'will accept an executable' do
      expect(@action.executable).to eq('executable')
    end
    it 'will accept parameters' do
      expect(@action.parameters).to eq('parameters')
    end
  end

  # context 'parse command column' do
  #   context 'single parameter' do
  #     before(:all) do
  #       @action = TaskAction.create(
  #           task_id: 1,
  #           command: 'folder/executable parameters',
  #           )
  #     end
  #
  #     it 'will parse command string into folder, executable' do
  #       expect(@action.folder).to eq('folder')
  #     end
  #     it 'will parse command string into folder, executable and parameters' do
  #       expect(@action.executable).to eq('executable')
  #     end
  #     it 'will parse the parameters' do
  #       expect(@action.parameters).to eq('parameters')
  #     end
  #   end
  #   context 'complex parameter' do
  #     before(:all) do
  #       @action = TaskAction.create(
  #           task_id: 1,
  #           command: 'folder/executable parm1 parm2 parm3',
  #           )
  #     end
  #
  #     it 'will parse command string into folder, executable' do
  #       expect(@action.folder).to eq('folder')
  #     end
  #     it 'will parse command string into folder, executable and parameters' do
  #       expect(@action.executable).to eq('executable')
  #     end
  #     it 'will parse the parameters' do
  #       expect(@action.parameters).to eq('parm1 parm2 parm3')
  #     end
  #   end
  # end

end