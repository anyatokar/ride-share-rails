class PassengersController < ApplicationController
  def index
    # @passengers = Passenger.all
    @passengers = Passenger.paginate(page: params[:page]).order("id")
  end
end
