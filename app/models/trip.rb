class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  def to_currency
    currency = (self.cost.to_i)/(100.0).round(2)
    return currency
  end
end
