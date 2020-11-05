require "test_helper"

describe TripsController do

  describe "index" do
    it "should get index" do
      get "/trip"
      must_respond_with :success
    end
  end

  describe "show" do
    before do
      @trip = Trip.create(driver_id: kendrick_jr.id,
                          passenger_id: joe_biden.id,
                          date: "2020-11-04",
                          rating: "5",
                          cost: "5000")
    end

    it "will get show for valid ids" do
      # Arrange
      valid_trip_id = @trip.id

      # Act
      get "/trips/#{valid_trip_id}"

      # Assert
      must_respond_with :success
    end

    it "will respond with not_found for invalid ids" do
      # Arrange
      invalid_trip_id = -1

      # Act
      get "/trips/#{invalid_trip_id}"

      # Assert
      must_respond_with :not_found
    end
  end

  describe "create" do

    let (:kendrick_jr) {
      Driver.create(name: "Kendrick Marks Jr")
    }

    it "can create a book" do
      trip_hash = {
        trip: {
          driver_id: mark_marks.id,
          passenger_id: michelle_obama.id,
          date: "2021-01-20",
          rating: "4",
          cost: "4000",
        }
      }

      expect {
        post trips_path, params: trip_hash
      }.must_differ 'Trip.count', 1

      must_respond_with :redirect
      must_redirect_to root_path

      expect(Trip.last.driver_id).must_equal trip_hash[:trip][:driver_id]
      expect(Trip.last.driver_id.name).must_equal mark_marks.name
      expect(Trip.last.passenger_id).must_equal trip_hash[:trip][:passenger_id]
      expect(Trip.last.passenger_id.name).must_equal michelle_obama.name
      expect(Trip.last.date).must_equal trip_hash[:trip][:date]
      expect(Trip.last.rating).must_equal trip_hash[:trip][:rating]
      expect(Trip.last.cost).must_equal trip_hash[:trip][:cost]
    end

    it "will not create a trip with invalid params" do
      # TODO fill this in when we implement validations next week
    end
  end


  describe "edit" do
    before do
      Trip.create(driver_id: kendrick_jr.id,
                  passenger_id: joe_biden.id,
                  date: "2020-11-04",
                  rating: "5",
                  cost: "5000")
    end

    let (:kendrick_jr) {
      Driver.create(name: "Kendrick Marks Jr") # TODO need more clarity on let
    }

    let (:joe_biden) {
      Passenger.create(name: "Joe Biden")
    }

    let (:mark_marks) {
      Driver.create(name: "Mark Marks")
    }

    let (:michelle_obama) {
      Passenger.create(name: "Michelle Obama")
    }

    let (:new_trip_hash) {
      {
        trip: {
          driver_id: mark_marks.id,
          passenger_id: michelle_obama.id,
          date: "2021-01-20",
          rating: "4",
          cost: "4000",
        },
      }
    }

    it "responds with success when getting the edit page for an existing, valid trip" do
      # Arrange
      # Ensure there is an existing trip saved
      valid_id = Trip.last.id

      # Act
      get edit_task_path(valid_id)

      # Assert
      expect {
        patch trip_path(valid_id), params: new_trip_hash
      }.wont_change "Trip.count"

      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing trip" do
      # Arrange
      # Ensure there is an invalid id that points to no trip
      invalid_id = -1

      # Act
      get edit_task_path(invalid_id)

      # Assert
      must_respond_with :redirect

      expect {
        patch trip_path(invalid_id), params: new_trip_hash
      }.wont_change "Trip.count"

    end
  end

  describe "update" do
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

    let (:mark_marks) {
      Driver.create(name: "Mark Marks")
    }

    let (:michelle_obama) {
      Passenger.create(name: "Michelle Obama")
    }

    let (:new_trip_hash) {
      {
        trip: {
          driver_id: mark_marks.id,
          passenger_id: michelle_obama.id,
          date: "2021-01-20",
          rating: "4",
          cost: "4000",
        },
      }
    }
    it "will update a model with a valid post request" do
      id = Trip.first.id
      expect {
        patch trip_path(id), params: new_trip_hash
      }.wont_change "Trip.count"

      must_respond_with :redirect

      trip = Trip.find_by(id: id)
      expect(trip.driver_id).must_equal new_trip_hash[:trip][:driver_id]
      expect(trip.passenger_id.name).must_equal new_trip_hash michelle_obama.name
      expect(trip.date).must_equal new_trip_hash[:trip][:date]
      expect(trip.rating).must_equal new_trip_hash[:trip][:rating]
      expect(trip.cost).must_equal new_trip_hash[:trip][:cost]
    end

    it "will respond with not_found for invalid ids" do
      id = -1

      expect {
        patch trip_path(id), params: new_trip_hash
      }.wont_change "Trip.count"

      must_respond_with :not_found
    end

    it "will not update if the params are invalid" do
      # TODO This test will be examined when we cover validations next week
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

    it "will reduce number of existing trips by 1" do
      trip = Trip.last

      expect(trip).must_be_instance_of Trip

      expect {
        delete trip_path(trip.id)
      }.must_change "Trip.count", -1
    end
  end
end
