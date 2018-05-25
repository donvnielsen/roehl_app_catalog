require 'active_record'

class RoehlApplication < ActiveRecord::Base
  validates :name,presence: true, uniqueness: {case_sensitive: false}

  after_initialize :init

  before_save :strip_columns,:downcase_columns

  ERR_INVALID_ID = 'id must reference existing server'

  def init
    self.name ||= ''
    self.description ||= ''
  end

  def strip_columns
    self.name.strip! unless self.name.nil?
    self.description.strip! unless self.description.nil?
  end

  def downcase_columns
    self.name.downcase! unless self.name.nil?
  end
end