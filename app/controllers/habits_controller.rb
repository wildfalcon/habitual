class HabitsController < ApplicationController
  before_filter :check_logged_in

  inherit_resources
  
  respond_to :json
  
  protected
  def begin_of_association_chain
    current_user  
  end
  
  def check_logged_in
    do403 unless user_logged_in?
  end
end
