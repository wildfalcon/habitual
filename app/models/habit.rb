class Habit < ActiveRecord::Base
  before_create :set_start_date
  
  private
  
  def set_start_date
    self.start_date = Time.now.to_date
  end

end
