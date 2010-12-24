class CommonHabit < ActiveRecord::Base
  has_many :habits

  scope :featured, where(:featured => true)
end
