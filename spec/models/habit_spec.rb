require 'spec_helper'

describe Habit do
  describe "on create" do
    it "should set start_date to today" do
      habit = Habit.create!
      habit.start_date.should == Time.now.to_date
    end
  end
end
