class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :all # include all helpers, all the time

end
