class AddSentToMailchimp < ActiveRecord::Migration
  def self.up
    add_column :users, :sent_to_mailchimp, :boolean, :default => false
  end

  def self.down
    remove_column :users, :sent_to_mailchimp
  end
end
