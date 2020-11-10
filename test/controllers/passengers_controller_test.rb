require "test_helper"

describe PassengersController do
  describe "index" do
    it "responds with success when there are many passengers saved" do
      # Arrange
      Passenger.create(name: "Kari", phone_num: "617-375-2945")
      Passenger.create(name: "Kendrick Marks Jr", phone_num: "613-375-2945")

      expect(Passenger.all).wont_be_empty
      expect(Passenger.all).wont_be_nil

      # Act
      get passengers_path

      # Assert
      must_respond_with :success

    end

    it "responds with success when there are no passengers saved" do
      # Arrange
      Passenger.destroy_all
      expect(Passenger.all.length).must_equal 0

      # Act
      get passengers_path

      # Assert
      must_respond_with :success

    end
  end

  describe "show" do
    before do
      @passenger = Passenger.create(name: "Kendrick Marks Jr", phone_num: "836-343-3439")
    end
    it "responds with success when showing an existing valid passenger" do
      # Arrange
      valid_passenger_id = @passenger.id

      # Act
      get passenger_path(valid_passenger_id)

      # Assert
      must_respond_with :success

    end

    it "responds with redirect with an invalid passenger id" do
      # Arrange
      invalid_passenger_id = -1

      expect(Passenger.find_by(id: invalid_passenger_id)).must_be_nil
      # Act
      get passenger_path(invalid_passenger_id)

      # Assert
      must_redirect_to passengers_path

    end
  end

  describe "new" do
    it "responds with success" do

      get new_passenger_path

      must_respond_with :success

    end
  end

  describe "create" do
    before do
      Passenger.destroy_all
      @new_passenger_hash = {
        passenger: {
          name: "Kendrick Marks Jr",
          phone_num: "567-456-4567"
        }
      }
    end
    it "can create a new passenger with valid information accurately, and redirect" do

      # Arrange
      # Set up the form data -- in let block
      # Act-Assert
      expect {
        post passengers_path, params: @new_passenger_hash
      }.must_differ 'Passenger.count', 1

      # Assert
      expect(Passenger.last.name).must_equal @new_passenger_hash[:passenger][:name]
      expect(Passenger.last.phone_num).must_equal @new_passenger_hash[:passenger][:phone_num]
      # Check that the controller redirected the user
      new_passenger_id = Passenger.find_by(name: "Kendrick Marks Jr").id
      must_respond_with :redirect
      must_redirect_to passenger_path(new_passenger_id)
    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      # TODO Note: This will not pass until ActiveRecord Validations lesson
    end
  end

  describe "edit" do
    before do
      @passenger = Passenger.create(name: "Kendrick Marks Jr", phone_num: "456-345-3245",)
    end

    it "responds with success when getting the edit page for an existing, valid passenger" do
      # Arrange

      valid_passenger_id = @passenger.id

      # Act
      get edit_passenger_path(valid_passenger_id)

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing passenger" do
      # Arrange
      invalid_passenger_id = -1

      expect(Passenger.find_by(id: invalid_passenger_id)).must_be_nil

      # Act
      get edit_passenger_path(invalid_passenger_id)

      # Assert
      must_redirect_to passengers_path

    end
  end

  describe "update" do
    before do
      @new_passenger_hash = {
        passenger: {
          name: "Kendrick Marks Jr",
          phone_num: "567-456-4567"
        }
      }

    Passenger.create(name: "Mark Marks", phone_num: "384-343-4583")
    end


    it "can update an existing passenger with valid information accurately, and redirect" do
      # Arrange
      valid_passenger_id = Passenger.find_by(name: "Mark Marks").id

      expect {
        patch passenger_path(valid_passenger_id), params: @new_passenger_hash
      }.wont_change "Passenger.count"

      # patch passenger_path(valid_passenger_id), params: @new_passenger_hash

      # Assert

      passenger = Passenger.find_by(id: valid_passenger_id)
      expect(passenger.name).must_equal @new_passenger_hash[:passenger][:name]
      expect(passenger.phone_num).must_equal @new_passenger_hash[:passenger][:phone_num]

      # Check that the controller redirected the user
      must_respond_with :redirect
      must_redirect_to passenger_path(valid_passenger_id)
    end

    it "does not update any passenger if given an invalid id, and responds with a 404" do
      # Arrange
      invalid_passenger_id = -1
      # Ensure there is an invalid id that points to no passenger

      expect(Passenger.find_by(id: invalid_passenger_id)).must_be_nil

      # Set up the form data - in let block

      # Act-Assert
      expect{
        patch passenger_path(invalid_passenger_id), params: @new_passenger_hash
      }.wont_change "Passenger.count"

      # Assert
      # Check that the controller gave back a redirect
      must_redirect_to passengers_path
    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      # TODO Note: This will not pass until ActiveRecord Validations lesson
    end
  end

  describe "destroy" do
    before do
      Driver.destroy_all
      @passenger = Passenger.create(name: "Kendrick Marks Jr",
                       phone_num: "293-342-3948")
    end

    it "destroys the passenger instance in db when passenger exists, then redirects" do
      # Arrange
      # Ensure there is an existing passenger saved
      # passenger = Passenger.last
      valid_passenger_id = Passenger.find_by(name: "Kendrick Marks Jr").id
      # Act-Assert
      # Ensure that there is a change of -1 in Passenger.count

      expect {
        delete passenger_path(valid_passenger_id)
      }.must_change "Passenger.count", -1

      # Assert
      # Check that the controller redirects
      must_respond_with :redirect

    end

    it "does not change the db when the passenger does not exist, then responds with " do
      # TODO need to think about which pages we want to redirect to and when
      # Arrange
      # Ensure there is an invalid id that points to no passenger
      invalid_passenger_id = -1
      expect(Passenger.find_by(id: invalid_passenger_id)).must_be_nil

      # Act-Assert
      # Ensure that there is no change in Passenger.count
      expect{
        delete passenger_path(invalid_passenger_id)
      }.wont_change "Passenger.count"

      # Assert
      # Check that the controller responds or redirects with whatever your group decides
      must_redirect_to passengers_path
    end
  end
end

