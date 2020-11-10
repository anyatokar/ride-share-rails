class DriversController < ApplicationController
  def index
    @drivers = Driver.paginate(page: params[:page]).order("id")
  end

  def show
    driver_id = params[:id]
    @driver = Driver.find_by(id: driver_id)
    if @driver.nil?
      flash[:red] = "Driver not found."
      redirect_to drivers_path
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      flash[:green] = "#{@driver.name} has been successfully created."
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
      # head :not_found
      flash[:red] = "Driver not found."
      redirect_to drivers_path
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      # head :not_found
      flash[:red] = "Driver not found."
      redirect_to drivers_path
      return
    elsif @driver.update(driver_params)
      flash[:green] = "Driver details have been successfully updated."
      redirect_to driver_path(@driver) # go to the index so we can see the book in the list
      return
    else # save failed :(
    render :edit # show the new book form view again
    return
    end
  end

  def destroy
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      flash[:red] = "Driver not found."
      redirect_to drivers_path
      return
    elsif Trip.where(driver_id: @driver.id).count > 0 # @lee: if the driver has trips, we want to destroy them first; otherwise, the delete driver button will cause an error
      Trip.where(driver_id: @driver.id).destroy_all
      @driver.destroy
      flash[:red] = "#{@driver.name} has been permanently deleted."
      redirect_to drivers_path
      return
    else
      @driver.destroy
      flash[:red] = "#{@driver.name} has been permanently deleted."
      redirect_to drivers_path
      return
    end
  end

  private
  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end
end
