class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  def to_currency(amount)
    currency = amount.to_i/(100.0).round(2)
    return currency
  end
end
