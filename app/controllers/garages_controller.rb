class GaragesController < ApplicationController
  def index
    @garages = Garage.all
  end

  def update
    @garage = Garage.find(params[:id])
    if @garage.update(garage_params)
      render json: @garage
    else
      render json: @garage.errors, status: :unprocessable_entity
    end
  end

  def create
    @garage = Garage.new(garage_params)

    if @garage.save
      render json: @garage
    else
      render json: @garage.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @garage = Garage.find(params[:id])
    # @garage.destroy
    head :no_content
  end

  private
  def garage_params
    params.require(:garage).permit(:name, :car_type, :year)
  end
end
