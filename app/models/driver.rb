class Driver < ApplicationRecord
  has_many :trips

  def average_rating
    nil_counter = 0
    rating_sum = self.trips.inject(0) do |sum, trip|
      if trip.rating.nil?
        sum + 0
        nil_counter += 1
      else
        sum + trip.rating.to_i
      end
    end

    num_ratings = (self.trips.length) - nil_counter
    average = (rating_sum/num_ratings.to_f).round(1)
    return average
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