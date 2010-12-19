class HomeController < ApplicationController
  def index
    redirect_to habits_path if user_logged_in?
  end

end
