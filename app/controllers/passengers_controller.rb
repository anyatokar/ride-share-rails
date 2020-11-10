class PassengersController < ApplicationController
  def index
    @passengers = Passenger.paginate(page: params[:page]).order("id")
  end

  def show
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)
    if @passenger.nil?
      flash[:red] = "Passenger not found."
      redirect_to passengers_path
      return
    end
  end

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params)
    if @passenger.save
      flash[:green] = "#{@passenger.name} has been successfully created."
      redirect_to passenger_path(@passenger)
      return
    else
      render :new
      return
    end
  end

  def edit
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      flash[:red] = "Passenger not found."
      redirect_to passengers_path
      return
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])
    if @passenger.nil?
      flash[:red] = "Passenger not found."
      redirect_to passengers_path
      return
    elsif @passenger.update(passenger_params)
      flash[:green] = "Passenger details have been successfully updated."
      redirect_to passenger_path(@passenger)
      return
    else
    render :edit
    return
    end
  end

  def destroy
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      flash[:red] = "Passenger not found."
      redirect_to passengers_path
      return
    elsif Trip.where(passenger_id: @passenger.id).count > 0 # @ lee: if the passenger has trips, we want to destroy them first; otherwise, the delete passenger button will cause an error
      Trip.where(passenger_id: @passenger.id).destroy_all
      @passenger.destroy
      redirect_to passengers_path
      return
    else
      @passenger.destroy
      flash[:red] = "#{@passenger.name} has been permanently deleted."
      redirect_to passengers_path
      return
    end
  end

  private
  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
