class Genre < ActiveRecord::Base
  validates :title, :presence => true

  has_many :genre_movie_joins,
     class_name: "GenreMovieJoin",
     foreign_key: :genre_id

  has_many :genre_movies,
    through: :genre_movie_joins,
    source: :movie

  def as_json(options={})
    super(options.merge(:except => [:created_at, :updated_at]))
  end
  
  def movies_with_rating(cur_user)
    movie_ids_array = self.genre_movie_joins.map(&:movie_id)
    return Movie.selected_movie_ratings(cur_user, movie_ids_array)
  end
end
