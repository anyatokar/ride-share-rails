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
      @driver = Driver.create(name: "Kendrick Marks Jr", vin: "YUJ9KT8HTOL8WX8NM", available: "false")
    end
    it "responds with success when showing an existing valid driver" do
      # Arrange
      # Ensure that there is a driver saved
      valid_driver_id = @driver.id

      # Act
      # get "/drivers/#{valid_driver_id}"
      get drivers_path(valid_driver_id)

      # Assert
      must_respond_with :success

    end

    it "responds with 404 with an invalid driver id" do
      # Arrange
      invalid_driver_id = -1
      # Ensure that there is an id that points to no driver
      expect(Driver.find_by(id: invalid_driver_id)).must_be_nil
      # Act
      get drivers_path(invalid_driver_id)

      # Assert
      must_respond_with :not_found

    end
  end

  describe "new" do
    it "responds with success" do

      get new_driver_path

      must_respond_with :success

    end
  end

  describe "create" do
    let (:new_driver_hash) {
      {
        driver: {
          name: "Mark Marks",
          vin: "YUJ9KT8HTOL8WX8NM",
          available: "true",
        },
      }
    }
    it "can create a new driver with valid information accurately, and redirect" do

      # Arrange
      # Set up the form data -- in let block
      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect {
        post drivers_path, params: new_driver_hash
      }.must_differ 'Driver.count', 1

      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      expect(Driver.last.name).must_equal new_driver_hash[:driver][:name]
      expect(Driver.last.vin).must_equal new_driver_hash[:driver][:vin]
      expect(Driver.last.available).must_equal new_driver_hash[:driver][:available]
      # Check that the controller redirected the user
      new_driver_id = Driver.last.id
      must_respond_with :redirect
      must_redirect_to "/drivers/#{new_driver_id}" #TODO what's the syntax for using paths here? drivers_path(new_driver_id) it's not this..
      # must_redirect_to drivers_path(new_driver_id)
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
      get "/drivers/#{invalid_driver_id}"

      # Assert
      must_respond_with :not_found

    end
  end

  describe "update" do
    before do
      Driver.create(
          name: "Kendrick Marks Jr",
          vin: "EMX66UMPBYNHH790R",
          available: "false"
      )
    end

    let (:new_driver_hash) {
      {
        driver: {
          name: "Mark Marks",
          vin: "EMX67UMPBYNHH790R",
          available: "true",
        },
      }
    }
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved


      # Assign the existing driver's id to a local variable
      valid_driver_id = Driver.last.id

      # Ensure that there is no change in Driver.count
      # expect(Driver.find_by(id: valid_driver_id)).must_equal 1
      expect {
        patch driver_path(valid_driver_id), params: new_driver_hash
      }.wont_change "Driver.count"

      patch driver_path(valid_driver_id), params: new_driver_hash

      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated

      driver = Driver.find_by(id: valid_driver_id)
      expect(driver.name).must_equal new_driver_hash[:driver][:name]
      expect(driver.vin).must_equal new_driver_hash[:driver][:vin]
      expect(driver.available).must_equal new_driver_hash[:driver][:available]

      # Check that the controller redirected the user
      must_respond_with :redirect
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      # Arrange
      invalid_driver_id = -1
      # Ensure there is an invalid id that points to no driver

      expect(Driver.find_by(id: invalid_driver_id)).must_be_nil

      # Set up the form data - in let block

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(invalid_driver_id), params: new_driver_hash
      }.wont_change "Driver.count"

      # Assert
      # Check that the controller gave back a 404
      must_respond_with :not_found
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
      must_respond_with :not_found

    end
  end
end
