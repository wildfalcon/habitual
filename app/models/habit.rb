class Habit < ActiveRecord::Base

  belongs_to :user
  belongs_to :common_habit

  scope :completed, where(:completed => true)
  scope :uncompleted, where(:completed => false)

  before_create :set_start_date
  before_save :complete_if_done

  validate do
    errors.add(:last_completed_date, "must be after start_date") unless last_completed_date.blank? || last_completed_date >= start_date
    if last_completed_date.present? && (last_completed_date - 29.days) > start_date
      errors.add(:last_completed_date, "must be within 30 days of start date") 
    end
  end

  private

  def set_start_date
    self.start_date = Time.now.to_date
  end
  
  def complete_if_done
    if last_completed_date.present? && (last_completed_date - 28.days) > start_date
      self.completed =  true
    end
  end

end
