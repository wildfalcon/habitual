class CreateHabits < ActiveRecord::Migration
  def self.up
    create_table :habits do |t|
      t.string :name
      t.date :start_date
      t.date :last_completed_date
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :habits
  end
end
