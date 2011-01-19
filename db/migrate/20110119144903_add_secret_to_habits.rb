class AddSecretToHabits < ActiveRecord::Migration
  def self.up
    add_column :habits, :secret, :boolean, :default => false
    
    Habit.all.each do |habit|
      habit.secret = false
      habit.save
    end
  end

  def self.down
    remove_column :habits, :secret
  end
end
