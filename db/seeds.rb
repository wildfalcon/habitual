# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

CommonHabit.find_or_create_by_title("Give up smoking", :name => "Don't Smoke", :featured => true)
CommonHabit.find_or_create_by_title("Learn Guitar", :name  => "Play chords for 30 minutes", :featured => true)
CommonHabit.find_or_create_by_title("Get Fit", :name  => "Do 15 minutes of cardio exercise", :featured => true)
CommonHabit.find_or_create_by_title("Wake up early", :name  => "Get out of bed by 7am", :featured => true)

