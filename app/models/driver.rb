class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true, length: { is: 17 }
  validates :available, inclusion: { in: ["true", "false"] }

  def average_rating
    nil_counter = 0
    rating_sum = 0
    self.trips.each do |trip|
      if trip.rating.nil?
        nil_counter += 1
      else
        rating_sum += trip.rating.to_f
      end
    end

    num_ratings = (self.trips.length) - nil_counter
    average = (rating_sum/num_ratings.to_f).round(1)
    return average
  end

  def total_earnings
    return 0 if self.trips.empty?
    net_fee = self.trips.inject(0) do |sum, trip|
      if trip.cost.nil? || trip.cost.to_f <= 1.65 * 100
        sum + 0
      else
        sum + (trip.cost.to_f - 165) * 0.8
      end
    end
    # return (net_fee / 100 * 0.8).round(2)
    return net_fee
  end

  def to_currency(amount)
    currency = amount.to_i/(100.0).round(2)
    return currency
  end
end


# def first_published
#   books_with_year = self.books.where.not(publication_date: nil)
#   first_book = books_with_year.order(publication_date: :asc).first
#   if first_book
#     return first_book.publication_date
#   else
#     return nil
#   end
# end