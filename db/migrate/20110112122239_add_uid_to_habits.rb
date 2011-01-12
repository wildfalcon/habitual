class AddUidToHabits < ActiveRecord::Migration
  def self.up
    add_column :habits, :uid, :string
    
    Habit.all.each do |habit|
      habit.uid = UUIDTools::UUID.timestamp_create
      habit.save
    end
  end

  def self.down
    remove_column :habits, :uid
  end
end
