class CreateCommonHabits < ActiveRecord::Migration
  def self.up
    create_table :common_habits do |t|
      t.string :title, :null => false
      t.string :name, :null => false
      t.boolean :featured

      t.timestamps
    end
  end

  def self.down
    drop_table :common_habits
  end
end
