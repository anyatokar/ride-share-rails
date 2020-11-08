require "test_helper"

describe Driver do
  let (:new_driver) {
    Driver.new(name: "Kari", vin: "IHNXZOJKN4H52RI3Z", available: "true")
  }
  it "can be instantiated" do
    # Assert
    expect(new_driver.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    new_driver.save
    driver = Driver.first
    [:name, :vin, :available].each do |field|

      # Assert
      expect(driver).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many trips" do
      # Arrange
      new_driver.save
      new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)

      # Assert
      expect(new_driver.trips.count).must_equal 2
      new_driver.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      new_driver.name = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :name
      expect(new_driver.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a VIN number" do
      # Arrange
      new_driver.vin = nil

      # Assert
      expect(new_driver.valid?).must_equal false
      expect(new_driver.errors.messages).must_include :vin
      expect(new_driver.errors.messages[:vin]).must_equal ["can't be blank", "is the wrong length (should be 17 characters)"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    describe "average rating" do
      it "can have many trips" do
        new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: "true")
        new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
        trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)

      expect(Driver.last.average_rating).must_equal (5 + 3) / 2
      end

      it "can account for nil trips and not add them to the total trips" do
        new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available:"true")
        new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1234)
        trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)
        trip_3 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: nil, cost: 1234)

        expect(Driver.last.average_rating).must_equal (5 + 3) / 2
      end
    end

    describe "total earnings" do
      it "sums total earnings" do
        Driver.destroy_all
        Trip.destroy_all
        Passenger.destroy_all
        new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available:"true")
        new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1000)
        trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 2000)
        trip_3 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: nil, cost: 3000)

        expect(new_driver.total_earnings).must_equal (6000 - (165 * 3)) * 0.8
      end
    end

    describe "can go online" do
      it "can online" do
        new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: "false")
        new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1000)

        new_driver.available = "true"

        expect(new_driver.available).must_equal "true"
      end
    end

    describe "can go offline" do
      it "can online" do
        new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: "true")
        new_passenger = Passenger.create(name: "Kari", phone_num: "111-111-1211")
        trip_1 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 5, cost: 1000)

        new_driver.available = "false"

        expect(new_driver.available).must_equal "false"
      end
    end

    end
  end


