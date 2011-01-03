class AddAddMoreCommonHabits < ActiveRecord::Migration
  def self.up
    CommonHabit.find_or_create_by_title("Take daily photos", :name  => "Take at least 1 photo", :featured => true)
    CommonHabit.find_or_create_by_title("Finish my book", :name  => "Write 500 words", :featured => true)
  end

  def self.down
  end
end
