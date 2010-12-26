class AddCompletedToHabit < ActiveRecord::Migration
  def self.up
    add_column :habits, :completed, :boolean, :default  => false
  end

  def self.down
    remove_column :habits, :completed
  end
end
