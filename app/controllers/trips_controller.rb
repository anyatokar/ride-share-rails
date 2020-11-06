class TripsController < ApplicationController
  def index
    @trips = Trip.paginate(page: params[:page]).order("id")
  end

  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    if @trip.nil?
      head :not_found
      return
    end
  end

  # def new
  #   @trip = Trip.new
  # end

  def create
    driver_to_assign =  Driver.find_by(available: "true")
    @trip = Trip.new(
      passenger_id: params[:passenger_id],
      driver_id: driver_to_assign.id,
      date: Date.today,
      cost: rand(1..5000), # set cost to random number
      rating: nil # set rating to nil
    )
    if @trip.save
      driver_to_assign.update(available: "false")
      redirect_to trip_path(@trip.id)
    else
      render :new #TODO: alert user somehow
      return
    end
    #
    # passenger_name = params[:trip][:passenger_name]
    # passenger = Passenger.find_by(name: passenger_name)
    # @trip = Trip.new(
    #   passenger_id: passenger.id,
    #   driver_id: 3,
    #   date: Date.today,
    #   cost: rand(1..5000), # set cost to random number
    #   rating: nil # set rating to nil
    # )
    # if @trip.save
    #   redirect_to trip_path(@trip.id)
    # else
    #   render :new #TODO: alert user somehow
    #   return
    # end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      head :not_found
      return
    elsif @trip.update(trip_edit_params)
      redirect_to trip_path(@trip)
      return
    else
    render :edit
    return
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    else
      @trip.destroy
      redirect_to passenger_path(@trip.passenger.id)
      return
    end
  end

  private
  def trip_edit_params
    return params.require(:trip).permit(:driver_id, :passenger_id, :cost, :rating) #TODO: should all params be required - yes otherwise edit won't work but what about a new trip that's being assigned a driver- shouldn't have all required?
  end

  # def trip_new_params
  #   return params.require(:trip).permit(:passenger_id)
  # end
end

