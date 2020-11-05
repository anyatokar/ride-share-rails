class DriversController < ApplicationController
  def index
    @drivers = Driver.all.sort
  end

  def show
    driver_id = params[:id]
    @driver = Driver.find_by(id: driver_id)
    if @driver.nil?
      head :not_found
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      redirect_to driver_path(@driver)
      return
    else
    render :new
    return
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      head :not_found
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to driver_path(@driver) # go to the index so we can see the book in the list
      return
    else # save failed :(
    render :edit # show the new book form view again
    return
    end
  end

  private
  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end
end
