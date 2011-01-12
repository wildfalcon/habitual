class Habit < ActiveRecord::Base
  include ActionView::Helpers::TextHelper #to get pluralize

  belongs_to :user
  belongs_to :common_habit

  scope :completed, where(:completed => true)
  scope :uncompleted, where(:completed => false)

  before_create :set_start_date
  before_save :complete_if_done
  before_save :post_to_facebook


  validate do
    errors.add(:last_completed_date, "must be after start_date") unless last_completed_date.blank? || last_completed_date >= start_date
    if last_completed_date.present? && (last_completed_date - 29.days) > start_date
      errors.add(:last_completed_date, "must be within 30 days of start date") 
    end
  end

  def number_of_completed_days
    return 0 if last_completed_date.blank?
    (last_completed_date - start_date).to_i + 1
  end

  private

  def set_start_date
    if new_record?
      self.start_date = Time.now.to_date
    end
  end

  def post_to_facebook
    post_start_to_facebook if new_record?
    post_progress_to_facebook if last_completed_date_changed?
    post_completion_to_facebook if last_completed_date_changed?
  end

  def post_start_to_facebook
    if new_record? and user.present?
      user.post_to_facebook("Started a new habit\n#{name}")
    end
  end
  
  def post_progress_to_facebook
    if [5,10,20].include? number_of_completed_days
      if user.present? 
        user.post_to_facebook("Managed to #{name}\nFor #{pluralize(number_of_completed_days, "day")} in a row")
      end
    end
  end
  
  def post_completion_to_facebook
    if (number_of_completed_days == 30) and user.present?
      user.post_to_facebook("Succesfully formed a habit: #{name}\n by doing it every day for 30 days in a row")
    end
  end

  def complete_if_done
    if number_of_completed_days > 29
      self.completed =  true
    end
  end

end
