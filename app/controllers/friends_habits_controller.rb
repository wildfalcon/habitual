class FriendsHabitsController < ApplicationController
  inherit_resources
  before_filter :check_logged_in
  
  actions :index
  respond_to :json
  
  protected
  def collection
    @friends ||= current_user.friends_with_habits.map{|u| {"habit_name" => u.habits.first.name, "name"=>u.name, "image" => u.profile_url}}
  end

  def check_logged_in
    do403 unless user_logged_in?
  end
end
