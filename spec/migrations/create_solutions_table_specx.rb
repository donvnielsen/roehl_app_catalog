require 'spec_helper'
require_relative '../../db/migrate/20180131140217_create_solutions_table'

describe 'Create Solution Table' do
  before do
    @my_migration_version = '20180131140217'
    @prev_migration_version = ''
  end

  describe 'up' do
    before do
      unless @prev_migration_version.nil? {
        ActiveRecord::Migrator.migrate @prev_migration_version
        puts "Testing up migration for #{@my_migration_version} - resetting to #{ActiveRecord::Migrator.current_version}"
      }
      end
    end

    pending "adds the columns to the users table" do
      # expect {
      #   CreateSolutionsTable.up
      #   Solution.reset_column_information
      # }.to change { Solution.columns }
      # expect {Solution.columns.map(&:name)}.to include('guid')
    end
  end

  pending 'describe down'
end
