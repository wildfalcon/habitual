class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :author
      t.string :author_link
      t.string :title
      t.date :publish_date
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
