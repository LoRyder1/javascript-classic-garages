class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @cars = []
    else
      @cars = Garage.search params[:q]
    end
  end
end
