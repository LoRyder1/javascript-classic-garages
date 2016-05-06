class GaragesController < ApplicationController
  def index
    @garages = Garage.all
  end

  def show
    @car = Garage.find(params[:id])
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
    @garage.destroy
    head :no_content
  end

  protected

  def find_car
    if id = Slug[params[:id]]
      @article = Garage.find(id)
    else
      @article = Garage.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end

  private
  def garage_params
    params.require(:garage).permit(:name, :car_type, :year)
  end
end
