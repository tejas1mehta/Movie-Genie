require 'rails_helper'

RSpec.describe UserRatingJoin, :type => :model do
  it "returns correct movie" do
    user_rating = UserRatingJoin.find_by_movie_id(2)
    expect(user_rating.movie).to eq(Movie.find(2))
  end
end
