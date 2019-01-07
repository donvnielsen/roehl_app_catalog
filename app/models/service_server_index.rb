require 'active_record'
require_relative '../../app/models/service'
require_relative '../../app/models/server'

# Links a scheduled task to the server it runs on
class ServiceServer < ActiveRecord::Base
  self.table_name = 'services_servers'

  belongs_to :services
  belongs_to :servers

  validates :service_id, presence: true
  validates :server_id, presence: true, uniqueness: { scope: :service_id }

  validate :check_service_references

  def init(server_id, service_id)
    self.server_id ||= server_id
    self.service_id ||= service_id
  end

  def check_service_references
    errors.add(:service_id, Service::ERR_INVALID_ID) if Service.find_by_id(self.service_id).nil?
    errors.add(:server_id, Server::ERR_INVALID_ID) if Server.find_by_id(self.server_id).nil?
  end

end
