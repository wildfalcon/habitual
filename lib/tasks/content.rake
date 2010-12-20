namespace :content do
  namespace :import do

    desc "Import articles from Steve Pavlina"
    task :pavlina  => :environment do
      Article.where(:author => "Steve Pavlina").destroy_all
      puts "Removed all articles by Steve Pavlina"
      
      text_01 = File.open("import/articles/pavlina/01.txt", "r").read
      Article.create!(
        :title => "30 Days to Success",
        :author => "Steve Pavlina",
        :author_link => "http://www.stevepavlina.com",
        :publish_date => Date.parse("2005-04-15"),
        :body  => text_01
      )
      text_02 = File.open("import/articles/pavlina/02.txt", "r").read
      Article.create!(
        :title => "Habit Change Is Like Chess",
        :author => "Steve Pavlina",
        :author_link => "http://www.stevepavlina.com",
        :publish_date => Date.parse("2008-07-29"),
        :body  => text_02
      )
      text_03 = File.open("import/articles/pavlina/03.txt", "r").read
      Article.create!(
        :title => "Goals Into Habits",
        :author => "Steve Pavlina",
        :author_link => "http://www.stevepavlina.com",
        :publish_date => Date.parse("2009-02-10"),
        :body  => text_03
      )
      puts "Created articles"
    end
    
  end
end