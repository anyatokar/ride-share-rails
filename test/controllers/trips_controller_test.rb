require "test_helper"

describe TripsController do

  # describe "index" do -- deleted due to RESTful routes
  #   it "should get index" do
  #     get trips_path
  #     must_respond_with :success
  #   end
  # end

  describe "show" do

    let (:kendrick_jr) {
      Driver.create!(name: "Kendrick Marks Jr", vin: "BZ7DZZM8H4O2PC34Q", available: "true")
    }

    let (:michelle_obama) {
      Passenger.create!(name: "Kendrick Marks Jr", phone_num: "234-586-4956")
    }

    it "will get show for valid ids" do
      # Arrange
      kendrick_jr
      post passenger_trips_path(michelle_obama.id)

      valid_trip_id = Trip.last.id

      # Act
      get trip_path(valid_trip_id)

      # Assert
      must_respond_with :success
    end

    it "will respond with not_found for invalid ids" do
      # Arrange
      invalid_trip_id = -1

      # Act
      get trip_path(invalid_trip_id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "create" do
    let (:kendrick_jr) {
      Driver.create!(name: "Kendrick Marks Jr", vin: "BZ7DZZM8H4O2PC34Q", available: "true")
    }

    let (:michelle_obama) {
      Passenger.create!(name: "Kendrick Marks Jr", phone_num: "234-586-4956")
    }

    it "can create a trip" do
      kendrick_jr
      expect {
        post passenger_trips_path(michelle_obama.id)
      }.must_differ 'Trip.count', 1

      must_respond_with :redirect
      must_redirect_to trip_path(Trip.last)

      # expect(Trip.last.driver_id).must_equal kendrick_jr.id.to_s
      expect(Trip.last.driver.name).must_equal kendrick_jr.name
      # expect(Trip.last.passenger_id).must_equal michelle_obama.id.to_s
      expect(Trip.last.passenger.name).must_equal michelle_obama.name
      Date.parse(Trip.last.date)
      expect(Trip.last.rating).must_be_nil
      expect(Trip.last.cost.to_i >= 1).must_equal true
      expect(Trip.last.cost.to_i <= 5000).must_equal true
    end

    it "will not create a trip with invalid params" do
      kendrick_jr
      post passenger_trips_path(michelle_obama.id)
      id = (michelle_obama.id + 1)

      # should raise error because the id is nil
      expect { post passenger_trips_path(id) }.must_raise NoMethodError
    end
  end

  describe "edit" do
    let (:kendrick_jr) {
    Driver.create(name: "Kendrick Marks Jr", vin: "BZ7DZZM8H4O2PC34Q", available: "true")
    }

    let (:joe_biden) {
      Passenger.create(name: "Joe Biden",  phone_num: "234-586-4956")
    }

    let (:mark_marks) {
      Driver.create(name: "Mark Marks", vin: "B97DZZM8H4O2PC34Q", available: "true")
    }

    let (:michelle_obama) {
      Passenger.create(name: "Michelle Obama", phone_num: "234-086-4956")
    }

    it "responds with success when getting the edit page for an existing, valid trip" do
      # Arrange
      # Ensure there is an existing trip saved
      kendrick_jr
      post passenger_trips_path(michelle_obama.id)

      valid_id = Trip.last.id

      # Act
      get edit_trip_path(valid_id)

      # Assert

      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing trip" do
      # Arrange
      # Ensure there is an invalid id that points to no trip
      invalid_id = -1

      # Act
      get edit_trip_path(invalid_id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:kendrick_jr) {
      Driver.create(name: "Kendrick Marks Jr", vin: "BZ7DZZM8H4O2PC34Q", available: "true")
    }

    let (:michelle_obama) {
      Passenger.create(name: "Michelle Obama", phone_num: "234-086-4956")
    }

    it "will update a model with a valid post request (add a rating)" do
      kendrick_jr
      post passenger_trips_path(michelle_obama.id)
      id = Trip.last.id

      # expect {
      #   patch trip_path(id), params[:trip.update(trip_edit_params)
      # }.wont_change "Trip.count"

      expect { Trip.last.update(rating: "4") }.wont_change "Trip.count"

      must_respond_with :redirect

      trip = Trip.find_by(id: id)
      expect(trip.rating).must_equal "4"
    end

    it "will respond with not_found for invalid ids" do
      id = -1

      expect {
        patch trip_path(id)
      }.wont_change "Trip.count"

      must_respond_with :not_found
    end

    it "will not update if the params are invalid" do
      kendrick_jr
      post passenger_trips_path(michelle_obama.id)
      id = Trip.last.id

      expect { Trip.last.update(rating: "not a rating") }.wont_change Trip.last.rating
    end
  end


  describe "destroy" do
    let (:kendrick_jr) {
      Driver.create!(name: "Kendrick Marks Jr", vin: "BZ7DZZM8H4O2PC34Q", available: "true")
    }

    let (:michelle_obama) {
      Passenger.create!(name: "Michelle Obama", phone_num: "234-086-4956")
    }

    it "will reduce number of existing trips by 1" do
      kendrick_jr
      post passenger_trips_path(michelle_obama.id)

      id = Trip.last.id

      expect {
        delete trip_path(id)
      }.must_change "Trip.count", -1
    end
  end
end
