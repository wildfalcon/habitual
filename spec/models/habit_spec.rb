require 'spec_helper'

describe Habit do
  describe "on create" do
    it "should set start_date to today" do
      habit = Habit.create!
      habit.start_date.should == Time.now.to_date
    end
  end
  
  describe "changing last_completed_date" do
    before(:each) do
      @habit = Factory(:habit, :start_date => Date.today)
    end
    
    it "should be invalid if before start_date" do
      @habit.last_completed_date = Date.today - 1.day
      @habit.should_not be_valid
    end
    
    it "should be valid if the start date" do
      @habit.last_completed_date = @habit.start_date
      @habit.should be_valid
    end
    
    it "should be invalid if more than 29 days after start date" do
      @habit.last_completed_date = Date.today + 30.days
      @habit.should_not be_valid
    end
    
    it "should be valid if 29 days after start date" do
      @habit.last_completed_date = Date.today + 29.days
      @habit.should be_valid      
    end
    
    it "should set compelted? if exactly 29 days after start_date" do
      @habit.last_completed_date = Date.today + 29.days
      @habit.save
      @habit.should be_completed
    end
    
    it "should not set compelted? if less than 30 days after start_date" do
      @habit.last_completed_date = Date.today + 28.days
      @habit.save
      @habit.should_not be_completed      
    end
  end
end
