require 'active_record'
require_relative '../../classes/log_formatter/log_cluster'

class Cluster < ActiveRecord::Base
  validates :name,presence: true, uniqueness: {case_sensitive: false}

  before_save :strip_columns, :lowercase_columns

  after_create :log_new_cluster

  def strip_columns
    self.name.strip! unless self.name.nil?
    self.description.strip! unless self.description.nil?
  end

  def lowercase_columns
    self.name.downcase! unless self.name.nil?
  end

  def log_new_cluster
    LOGGER.debug(LogCluster.msg(self, 'Created cluster')) if LOGGER.debug?
  end
end