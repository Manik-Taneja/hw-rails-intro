class Movie < ActiveRecord::Base
    def self.with_ratings(ratings)
        #returns the entire database of movies if no filters are applied
        return Movie.all unless ratings
        #creates a map of ratings as the key and movies as the values
        ratings = ratings.map { |rating| rating.upcase }
        #condition to restrict database query
        Movie.where(rating: ratings)
    end
    
    def self.all_ratings
        Movie.select(:rating).uniq.map do |record|
            record.rating
        end
    end
end