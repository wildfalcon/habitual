class AddCommonHabitIdToHabits < ActiveRecord::Migration
  def self.up
    add_column :habits, :common_habit_id, :integer
  end

  def self.down
    remove_column :habits, :common_habit_id
  end
end
