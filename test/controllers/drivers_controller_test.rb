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
      @driver = Driver.create(name: "Kendrick Marks Jr", vin: "IHNXZOJKN6H52RI3Z", available: "false")
    end
    it "responds with success when showing an existing valid driver" do
      # Arrange
      # Ensure that there is a driver saved

      valid_driver_id = @driver.id

      # Act
      get driver_path(valid_driver_id)

      # Assert
      must_respond_with :success

    end

    it "will redirect for an invalid driver id" do

      # Arrange
      invalid_driver_id = -1

      # Act
      expect(Driver.find_by(id: invalid_driver_id)).must_be_nil
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
      Driver.destroy_all
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
      @driver = Driver.create(name: "Kendrick Marks Jr", vin: "IHNXZO4KN4H52RI3Z", available: "false")
    end

    it "responds with success when getting the edit page for an existing, valid driver" do
      # Arrange

      valid_driver_id = @driver.id
      # Ensure there is an existing driver saved

      # Act
      get edit_driver_path(valid_driver_id)

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
      Driver.destroy_all
      @driver_hash = {
        driver: {
          name: "Kendrick Marks Jr",
          vin: "EMX66UMNBYNHH790R",
          available: "true"
        }
      }

    Driver.create(name: "Mark Marks", vin: "EMX67UMNBYNHH790R", available: "true")
    end

    it "can create a new driver with valid information accurately, and redirect" do

      id = Driver.find_by(name: "Mark Marks").id

      expect {
        patch driver_path(id), params: @driver_hash
      }.wont_change 'Driver.count'

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
      # Check that the controller gave back a redirect
      must_respond_with :redirect
    end

    # it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
    #   # TODO Note: This will not pass until ActiveRecord Validations lesson
    #   # Arrange
    #   # Ensure there is an existing driver saved
    #   # Assign the existing driver's id to a local variable
    #   # Set up the form data so that it violates Driver validations
    #
    #   # Act-Assert
    #   # Ensure that there is no change in Driver.count
    #
    #   # Assert
    #   # Check that the controller redirects
    #
    # end
  end

  describe "destroy" do
    before do
      Driver.destroy_all
      @driver = Driver.create(name: "Kendrick Marks Jr", vin: "IHNXZOJKN6H52RI3Z", available: "false")
    end

    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved
      # driver = Driver.last
      valid_driver_id = Driver.find_by(name: "Kendrick Marks Jr").id
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
      expect{
        delete driver_path(invalid_driver_id)
      }.wont_change "Driver.count"

      # Assert
      # Check that the controller responds or redirects with whatever your group decides
      must_redirect_to drivers_path
    end
  end
end