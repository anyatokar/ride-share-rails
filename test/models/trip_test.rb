require "test_helper"

describe Trip do
  describe "create" do
    let (:new_trip) {
      Trip.new(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
    }

    let (:new_driver) {
      Driver.create(name: "Kendrick Marks Jr", vin: "ALWSS52P9NEYLVDE9", available:"true")
    }

    let (:new_passenger) {
      Passenger.create(name: "Joe Biden", phone_num: "111-111-1211")
    }

    it "can be instantiated" do
      expect(new_trip.valid?).must_equal true
    end

    it "will have the required fields" do
      # Arrange
      new_trip.save
      trip = Trip.last
      [:driver_id, :passenger_id, :date, :rating, :cost].each do |field|

        # Assert
        expect(trip).must_respond_to field
      end
    end
  end

  describe "relationships" do
    it "can have many trips" do
    new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available:"true")
    new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
    trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
    trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
    new_driver_trip_count = Trip.all.find_all { |trip| trip.driver_id.to_i == new_driver.id.to_i}.length
    new_passenger_trip_count = Trip.all.find_all { |passenger| passenger.passenger_id.to_i == new_passenger.id.to_i}.length
    # Assert
    expect(new_driver_trip_count).must_equal 2
    expect(new_passenger_trip_count).must_equal 2
    end
  end

  describe "validations" do
    let (:new_trip) {
      Trip.new(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
    }

    let (:new_driver) {
      Driver.create(name: "Kendrick Marks Jr", phone_num: "111-111-1211")
    }

    let (:new_passenger) {
      Driver.create(name: "Joe Biden", vin: "ALWSS52P9NEYLVDE9", available:"true")
    }

    it "must have a passenger_id" do
      new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available:"true")
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      # Arrange
      new_trip = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
      new_trip.passenger_id = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :passenger_id
      expect(new_trip.errors.messages[:passenger_id]).must_equal ["can't be blank"] # TODO actually, the ids aren't being entered, so... we don't need these validations, right? so wouldnt need to validate a driver_id either...
    end

    it "must have a date" do
      # Arrange
      #
      new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available:"true")
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      # Arrange
      new_trip = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
      new_trip.date = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :date
      expect(new_trip.errors.messages[:date]).must_equal ["can't be blank"]
    end

    it "must have a rating" do # rating isn't required
      # Arrange
      new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available:"true")
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      # Arrange
      new_trip = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
      new_trip.rating = nil

      # Assert
      expect(new_trip.valid?).must_equal true
      # expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal []
    end

    it "must have a cost" do
      new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available:"true")
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      # Arrange
      new_trip = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
      # Arrange
      new_trip.cost = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :cost
      expect(new_trip.errors.messages[:cost]).must_equal ["can't be blank", "is not a number"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    # Your tests here
  end
end
