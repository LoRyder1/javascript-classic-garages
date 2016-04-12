class GaragesController < ApplicationController
  def index
    @garages = Garage.all
  end

  def create
    @garage = Garage.new(garage_params)

    if @garage.save
      render json: @garage
    else
      render json: @garage.errors, status: :unprocessable_entity
    end
  end

  private
  def garage_params
    params.require(:garage).permit(:name, :car_type, :year)
  end
end
