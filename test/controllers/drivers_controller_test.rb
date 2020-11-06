# TODO this is random method to generate license plates... keeping for now in case it'll come in handy
# generates random numbers, source: https://stackoverflow.com/questions/15790841/how-can-i-generate-random-mixed-letters-and-numbers-in-ruby
# def random_license_plate(length)
#   letters_and_numbers = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
#   license_plate = ""
#   length.times { |i| license_plate << letters_and_numbers[rand(36)] }
#   return license_plate
# end
# random_license_plate(17) # the ones in the csv file are 17 characters

require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.

  describe "index" do
    it "responds with success when there are many drivers saved" do
      # Arrange
      Driver.create(name: "Kari", vin: "IHNXZOJKN4H52RI3Z", available: "true")
      Driver.create(name: "Kendrick Marks Jr", vin: "JDO9OQL7AWDLZ1AY6", available: "false")

      # Ensure that there is at least one Driver saved
      expect(Driver.all).wont_be_empty
      expect(Driver.all).wont_be_nil

      # Act
      get drivers_path

      # Assert
      must_respond_with :success

    end

    it "responds with success when there are no drivers saved" do
      # Arrange
      # Ensure that there are zero drivers saved
      Driver.destroy_all
      expect(Driver.all.length).must_equal 0

      # Act
      get drivers_path

      # Assert
      must_respond_with :success

    end
  end

  describe "show" do
    before do
      @driver = Driver.create(name: "Kendrick Marks Jr", vin: "456", available: "false")
    end
    it "responds with success when showing an existing valid driver" do
      # Arrange
      # Ensure that there is a driver saved

      valid_driver_id = @driver.id

      # Act
      get "/drivers/#{valid_driver_id}"

      # Assert
      must_respond_with :success

    end

    it "will redirect for an invalid driver id" do

      # Arrange
      invalid_driver_id = -1

      # Act
      get driver_path(invalid_driver_id)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "responds with success" do

      get new_driver_path

      must_respond_with :success

    end
  end

  describe "create" do
    before do
      @driver_hash = {
        driver: {
          name: "Kendrick Marks Jr",
          vin: "EMX66UMNBYNHH790R",
          available: "false"
        }
      }
    end

    it "can create a new driver with valid information accurately, and redirect" do

      expect {
        post drivers_path, params: @driver_hash
      }.must_differ 'Driver.count', 1

      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      expect(Driver.last.name).must_equal @driver_hash[:driver][:name]
      expect(Driver.last.vin).must_equal @driver_hash[:driver][:vin]
      expect(Driver.last.available).must_equal @driver_hash[:driver][:available]
      # Check that the controller redirected the user
      must_respond_with :redirect
      # must_redirect_to "/drivers/#{new_driver_id}" this would've gone to the incorrect driver, the former one, did you mean the 2nd?
      id = Driver.find_by(name: "Kendrick Marks Jr").id
      must_redirect_to driver_path(id)
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # TODO Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects
    end
  end

  describe "edit" do
    before do
      @driver = Driver.create(name: "Kendrick Marks Jr", vin: "456", available: "false")
    end

    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange

      valid_driver_id = @driver.id
      # Ensure there is an existing driver saved

      # Act
      get "/drivers/#{valid_driver_id}"

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      # Arrange
      invalid_driver_id = -1

      # Ensure there is an invalid id that points to no driver
      expect(Driver.find_by(id: invalid_driver_id)).must_be_nil

      # Act
      get edit_driver_path(invalid_driver_id)

      # Assert
      must_respond_with :redirect

    end
  end

  describe "update" do
    before do
      @new_driver_hash = {
        driver_id: 1,
        passenger_id: 1,
        date: "2021-01-20",
        rating: "4",
        cost: "4000",
      }
    end

    # Act-Assert

    #TODO: did you know you're creating a trip here? Did you want to create a driver and test updating the driver instead?
    #  # @trip = Trip.create(
    #               driver_id: 1,
    #               passenger_id: 1,
    #               date: "2020-11-04",
    #               rating: "5",
    #               cost: "5000")
    #
    #   @hash = {
    #           driver_id: mark_marks.id,
    #           passenger_id: michelle_obama.id,
    #           date: "2021-01-20",
    #           rating: "4",
    #           cost: "4000",
    #           }
    # end
    #
    # let (:kendrick_jr) {
    #   Driver.create(name: "Kendrick Marks Jr")
    # }
    #
    # let (:joe_biden) {
    #   Passenger.create(name: "Joe Biden")
    # }
    #
    # let (:mark_marks) {
    #   Driver.create(name: "Mark Marks")
    # }
    #
    # let (:michelle_obama) {
    #   Passenger.create(name: "Michelle Obama")
    # }
    #
    # let (:new_driver_hash) {
    #   {
    #     trip: {
    #       driver_id: mark_marks.id,
    #       passenger_id: michelle_obama.id,
    #       date: "2021-01-20",
    #       rating: "4",
    #       cost: "4000",
    #     },
    #   }
    # }
    #
    # it "can update an existing driver with valid information accurately, and redirect" do
    #   # Arrange
    #   # Ensure there is an existing driver saved
    #
    #
    #   # Assign the existing driver's id to a local variable
    #   valid_driver_id = @trip.driver_id
    #
    #   # Ensure that there is no change in Driver.count
    #   # expect(Driver.find_by(id: valid_driver_id)).must_equal 1 #TODO: this is talking about a driver instance, not id
    #   expect {
    #     patch driver_path(valid_driver_id), params: @hash
    #   }.wont_change "Driver.count"
    #
    #   # Assert
    #   # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
    #
    #   # TODO: These are not being triggerd in the let, I would try rewriting as a before, as that fixed other tests in your suite
    #   # driver = Trip.find_by(name: new_driver_hash[:driver][:name])
    #   # expect(driver.name).must_equal new_driver_hash[:driver][:name]
    #   # expect(driver.vin).must_equal new_driver_hash [:driver][:vin]
    #   # expect(driver.available).must_equal new_driver_hash[:trip][:available]
    #
    #   # Check that the controller redirected the user
    # end

    it "does not update any driver if given an invalid id, and responds with a redirect" do
      # Arrange
      invalid_driver_id = -1
      # Ensure there is an invalid id that points to no driver
      #
      expect(Driver.find_by(id: invalid_driver_id)).must_be_nil

      # Set up the form data - in let block

      # Act-Assert
      # Ensure that there is no change in Driver.count
      count = Driver.count
      expect {
        patch driver_path(invalid_driver_id), params: @new_driver_hash
      }.wont_change count

      # Assert
      # Check that the controller gave back a 404
      must_respond_with :redirect
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # TODO Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects

    end
  end

  describe "destroy" do
    before do
      Trip.create(driver_id: kendrick_jr.id,
                  passenger_id: joe_biden.id,
                  date: "2020-11-04",
                  rating: "5",
                  cost: "5000")
    end

    let (:kendrick_jr) {
      Driver.create(name: "Kendrick Marks Jr")
    }

    let (:joe_biden) {
      Passenger.create(name: "Joe Biden")
    }
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved
      driver = Driver.last
      valid_driver_id = driver.id

      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count

      expect {
        delete driver_path(valid_driver_id)
      }.must_change "Driver.count", -1

      # Assert
      # Check that the controller redirects
      must_respond_with :redirect

    end

    it "does not change the db when the driver does not exist, then responds with " do
      # TODO need to think about which pages we want to redirect to and when
      # Arrange
      # Ensure there is an invalid id that points to no driver
      invalid_driver_id = -1
      expect(Driver.find_by(id: invalid_driver_id)).must_be_nil

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(invalid_driver_id)
      }.wont_change "Driver.count"

      # Assert
      # Check that the controller responds or redirects with whatever your group decides
      must_respond_with :redirect

    end
  end
end