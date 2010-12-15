class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :uid, :null => false
      t.string :access_token
      t.string :name
      t.string :email
      t.timestamps
    end

    # add_index :users, :email,                :unique => true
    add_index :users, :uid,                :unique => true
  end

  def self.down
    drop_table :users
  end
end
