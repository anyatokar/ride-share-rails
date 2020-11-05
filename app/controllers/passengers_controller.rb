class PassengersController < ApplicationController
  def index
    @passengers = Passenger.paginate(page: params[:page]).order("id")
  end

  def show
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)
    if @passenger.nil?
      head :not_found
      return
    end
  end

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params)
    if @passenger.save
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
      head :not_found
      return
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])
    if @passenger.nil?
      head :not_found
      return
    elsif @passenger.update(passenger_params)
      redirect_to passenger_path(@passenger) # go to the index so we can see the book in the list
      return
    else # save failed :(
    render :edit # show the new book form view again
    return
    end
  end

  private
  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
