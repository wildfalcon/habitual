class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :fb_uid
      t.timestamps
    end

    # add_index :users, :email,                :unique => true
    add_index :users, :fb_uid,                :unique => true
  end

  def self.down
    drop_table :users
  end
end
