require "test_helper"

describe Trip do
  let (:new_trip) {
    Trip.new(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
  }

  let (:new_driver) {
    Driver.create(name: "Kendrick Marks Jr")
  }

  let (:new_passenger) {
    Driver.create(name: "Joe Biden")
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

  describe "relationships" do
    # Arrange
    # new_trip.save # TODO stuck on this
    new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9")
    new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
    trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
    trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
    # Assert
    puts Trip.all.find_all { |trip| trip.driver_id == new_driver.id }
      # find_ { |trip| trip.driver_id == new_driver.id }
    # expect(Trip.all.find_all { |trip| trip.driver_id == new_driver.id }.length).must_equal 2
    # Trip.each do |trip|
    #   expect(Driver.find_by(driver_id: trip.driver_id)).must_be_instnace_of Driver
    #   expect(Passenger.find_by(passenger_id: trip.driver_id)).must_be_instnace_of Driver
    # end
  end

  describe "validations" do
    it "must have a passenger_id" do
      # Arrange
      new_trip.passenger_id = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :passenger_id
      expect(new_trip.errors.messages[:passenger_id]).must_equal ["can't be blank"] # TODO actually, the ids aren't being entered, so... we don't need these validations, right? so wouldnt need to validate a driver_id either...
    end

    it "must have a date" do
      # Arrange
      new_trip.date = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :date
      expect(new_trip.errors.messages[:vin]).must_equal ["can't be blank"] #TODO we can add regex if we want. what values do we want to accept?
    end

    it "must have a rating" do  #TODO rating is a must?
      # Arrange
      new_trip.rating = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal ["can't be blank"]
    end

    it "must have a cost" do
      # Arrange
      new_trip.cost = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :cost
      expect(new_trip.errors.messages[:cost]).must_equal ["can't be blank"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    # Your tests here
  end
end
