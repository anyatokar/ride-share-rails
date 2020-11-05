class DriversController < ApplicationController
  def index
    # @drivers = Driver.all
    @drivers = Driver.paginate(page: params[:page]).order("id")
  end
end
