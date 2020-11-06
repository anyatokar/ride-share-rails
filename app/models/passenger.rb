class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :phone_num, presence: true

  def total_spent
    total = 0
    self.trips.each do |trip|
      total += trip.cost.to_i
    end
    return total
  end

  def to_currency(amount)
    currency = amount.to_i/(100.0).round(2)
    return currency
  end
end
