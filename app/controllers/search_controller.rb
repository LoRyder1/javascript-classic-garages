class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @cars = []
    else
      @cars = Garages.search params[:q]
    end
  end
end
