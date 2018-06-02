require 'active_record'

class Cluster < ActiveRecord::Base
  validates :name,presence: true, uniqueness: {case_sensitive: false}

  before_save :strip_columns, :lowercase_columns

  def strip_columns
    self.name.strip! unless self.name.nil?
    self.description.strip! unless self.description.nil?
  end

  def lowercase_columns
    self.name.downcase! unless self.name.nil?
  end
end