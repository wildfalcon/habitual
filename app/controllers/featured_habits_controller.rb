class FeaturedHabitsController < ApplicationController
  inherit_resources
  actions :index
  respond_to :json
  
  protected
    def collection
      @featured_habits ||= CommonHabit.featured
    end

end
