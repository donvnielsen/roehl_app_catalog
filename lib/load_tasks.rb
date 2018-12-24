require 'standalone_migrations'
require 'ruby-progressbar'
require 'sqlite3'
require 'yaml'
require 'nokogiri'
require 'pp'

ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'
require_relative '../classes/log_formatter/log_task'
require_relative '../app/models/server'
require_relative '../app/models/task'
require_relative '../app/models/task_server_index'
require_relative '../classes/task_xml_file'

# ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(
  adapter: CONFIG_DB['adapter'],
  database: File.join(ROOT_DIR, CONFIG_DB['database']),
  logger: LOGGER
)
LOGGER.level = Logger::DEBUG
LOGGER.info('Tasks and Task Actions')

puts "Start #{Time.now}"

ActiveRecord::Migration.migrate(File.join(ROOT_DIR, CONFIG['dbdir'], 'migrate'))

# for each task, create entry and parse actions
def propagate_task(server, tasks)
  server_tasks = Dir.glob(File.join(tasks,'*.xml'))
  return if server_tasks.nil?
  LOGGER.info("Server #{server.name} tasks #{server_tasks.count}")

  pb = ProgressBar.create(
    title: 'Tasks',
    total: server_tasks.count,
    remainder_mark: '.',
    format: PROGRESS_BAR_OPTIONS[:fmt],
    length: PROGRESS_BAR_OPTIONS[:lg]
  )

  server_tasks.each do |entry|
    pb.increment
    task_xml = TaskXmlFile.new(entry)
    task = Task.create(
      name: task_xml.name,
      uri: task_xml.uri,
      description: task_xml.description,
      xml: task_xml.xml
    )

    TaskServer.create!(task_id: task.id, server_id: server.id)
    task_xml.actions.each { |action|
      TaskAction.create!(
        task_id: task.id,
        command: [action.command, action.arguments].join(' '),
        folder: File.dirname(action.command),
        executable: File.basename(action.command),
        parameters: action.arguments
      )
    }
  end

  pb.progress < pb.total ? pb.stop : pb.finish
end

Task.destroy_all
TaskServer.destroy_all

# look for tasks folders in each server. if found, then process
# each xml file in that folder, ensuring it is for a task.
Server.all.each do |server|
  next unless ['dev','test'].include?(ENV['RAILS_ENV']) && server.name.include?('pc1932')

  tasks_dir = File.join('//',server.name, CONFIG['taskssubdir'])
  propagate_task(server, tasks_dir) if Dir.exist?(tasks_dir)
  # relate tasks to server
end

LOGGER.info("End load_tasks, tasks = #{Task.count}")
