require 'active_record'

# describes a service running on one or more servers
class Service < ActiveRecord::Base
  self.table_name = 'services'

  validates :name, presence: true
  validates :pathname, presence: true
  validates :xml, presence: true

  before_save :strip_columns, :downcase_columns

  ERR_INVALID_ID = 'id must reference existing service'

  def init
    self.name ||= ''
    self.pathname ||= ''
    self.description ||= ''
    self.xml ||= ''
  end

  def strip_columns
    self.name.strip! unless self.name.nil?
    self.pathname.strip! unless self.pathname.nil?
    self.description.strip! unless self.description.nil?
  end

  def downcase_columns
    self.name.downcase! unless self.name.nil?
  end

end