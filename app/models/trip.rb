class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates :driver_id, :passenger_id, :date, :cost, presence: true
  validates :rating, inclusion: { in: [nil, "1", "2", "3", "4", "5"] }
  validates :cost, numericality: true

  def to_currency(amount)
    currency = amount.to_i/(100.0).round(2)
    return currency
  end
end
