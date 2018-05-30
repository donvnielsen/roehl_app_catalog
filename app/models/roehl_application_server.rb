require 'active_record'

class RoehlApplicationServer < ActiveRecord::Base
  self.table_name = 'roehl_applications_servers'

  belongs_to :roehl_applications
  belongs_to :servers

  validates :roehl_application_id, presence: true
  validates :server_id, presence: true, uniqueness: { scope: :roehl_application_id }

  ERR_INVALID_ID = 'id must reference existing roehl application'

  validate :check_references

  def check_references
    errors.add(:roehl_application_id, RoehlApplication::ERR_INVALID_ID) if RoehlApplication.find_by_id(self.roehl_application_id).nil?
    errors.add(:server_id, Server::ERR_INVALID_ID) if Server.find_by_id(self.server_id).nil?
  end

end

