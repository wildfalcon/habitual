# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

c1 = CommonHabit.find_or_create_by_title("Give up smoking", :name => "Not Smoke")
c1.featured = true
c1.save!

c2 = CommonHabit.find_or_create_by_title("Learn Guitar", :name  => "Play chords for 30 minutes")
c2.featured = true
c2.save!