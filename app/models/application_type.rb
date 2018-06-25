require 'active_record'

class ApplicationType < ActiveRecord::Base
  validates :name,presence: true, uniqueness: {case_sensitive: false}

  before_validation :strip_columns, :downcase_columns

  def downcase_columns
    self.name.downcase! unless self.name.nil?
  end

  def strip_columns
    self.name.strip! unless self.name.nil?
    self.description.strip! unless self.description.nil?
  end
end