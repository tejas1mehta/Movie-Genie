require 'matrix'

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class Movie < ActiveRecord::Base

  validates :title, :presence => true

  has_many :critic_reviews,
     class_name: "MovieCriticJoin",
     foreign_key: :movie_id

  has_many :genre_movie_joins,
     class_name: "GenreMovieJoin",
     foreign_key: :movie_id

  has_many :genres,
    through: :genre_movie_joins,
    source: :genre

  has_many :actor_movie_joins,
     class_name: "MovieActorJoin",
     foreign_key: :movie_id

  has_many :actors,
    through: :actor_movie_joins,
    source: :actor

  has_one :director_movie_join,
     class_name: "MovieDirectorJoin",
     foreign_key: :movie_id

  has_one :director,
    through: :director_movie_join,
    source: :director

  has_one :writer_movie_join,
     class_name: "MovieWriterJoin",
     foreign_key: :movie_id

  has_one :writer,
    through: :writer_movie_join,
    source: :writer

  has_one :studio_movie_join,
     class_name: "MovieStudioJoin",
     foreign_key: :movie_id

  has_one :studio,
    through: :studio_movie_join,
    source: :studio

  attr_accessor :predicted_rating

  def as_json(options={})
    super(options.merge(:only => [:title, :id, :photo_link, :in_theatre, :theatre_release_date], :methods => [:predicted_rating]))
  end

  def similar_movies
    movie_genre_vector =  Matrix.build(NUM_ALL_GENRES, 1){ -0.5 }    
    j = 0
    while j < NUM_ALL_GENRES
      genre_text = "genre" + j.to_s
      movie_genre_vector[j, 0] = 1 if (self.send(genre_text.to_sym) > 0)
      j += 1
    end    

    movie_details, movie_rating_vector, movie_genres_matrix = Movie.get_movie_genres
    similarity_vector = 5*(movie_genres_matrix*movie_genre_vector) + movie_rating_vector
    movie_with_similarity = [movie_details, similarity_vector.t.to_a.first]
    
    sorted_similar_movies = movie_with_similarity.transpose.sort_by(&:last).reverse
    return sorted_similar_movies[0, NUM_SIMILAR_MOVIES].transpose.first.map(&:id)
  end

  def self.selected_movie_ratings(user, movie_ids_array)
    all_movie_ratings = predict_ratings_ratings(user)
    return all_movie_ratings.select{|movie| movie_ids_array.include?(movie.id) }
  end

  def self.get_imp_attr_hash(movies)
    movies_array = []
    movies.each do |movie|
      movies_array.push({title: movie.title, id: movie.id, imdb_id: movie.imdb_id, predicted_rating: movie.predicted_rating})
    end

    return movies_array.to_json
  end

  def self.predict_ratings(user)
    
    movie_details, avg_movie_ratings, movie_genres_matrix = Movie.get_movie_genres
    user_genre_vector = user.get_genre_vector
    num_movies = avg_movie_ratings.row_size
    movie_compatibility = movie_genres_matrix*user_genre_vector
    movie_compatibility = ( movie_compatibility + Matrix.build(num_movies,1){ 4 })*(5.0/16.0)
    movie_rating = avg_movie_ratings + movie_compatibility
    movie_details.each_with_index{|movie, index| movie.predicted_rating = movie_rating[index,0].round(1) }

    return movie_details
  end

  def self.get_movie_genres(num_genres = 17)
    cached_movie_genres = Rails.cache.fetch("movie_genres", expires_in: 7.days) do
      all_movies = Movie.all # MAKE SURE MOVIES INRIGHT ORDER
      num_movies = all_movies.length

      movie_details = Movie.all #.pluck(:id, :imdb_id, :title)
      movie_rating_vector =  Matrix.build(num_movies, 1){ 0 }
      movie_genres_matrix =  Matrix.build(num_movies, num_genres){ 0 }
      load_movie_details = movie_details[0].id
      i = 0
      while i < num_movies
        movie_rating_vector[i,0] = all_movies[i].avg_rating_half_scale      

        j = 0
        while j < num_genres
          genre_text = "genre" + j.to_s
          movie_genres_matrix[i,j] = all_movies[i].send(genre_text.to_sym) 
          j += 1
        end
        i += 1
      end 

      [movie_details, movie_rating_vector, movie_genres_matrix]
    end
    
    return cached_movie_genres[0], cached_movie_genres[1], cached_movie_genres[2]
  end    

  def send_details
    cached_movie_details = Rails.cache.fetch("new_movie_details_#{self.id}", expires_in: 7.days) do
      { id: self.id,
      title: self.title,
      theatre_release_date: self.theatre_release_date,
      dvd_release_date: self.dvd_release_date,
      imdb_id: self.imdb_id,
      rt_id: self.rt_id,
      years_running: self.years_running,
      television_show: self.television_show,
      bollywood: self.bollywood,

      plot: self.plot,
      awards: self.awards,
      run_time: self.run_time,
      youtube_trailer_title: self.youtube_trailer_title,
      youtube_trailer: self.youtube_trailer,

      rt_audience_score: self.rt_audience_score,
      rt_critics_score: self.rt_critics_score,
      imdb_rating: self.imdb_rating,
      imdb_votes: self.imdb_votes,
      avg_rating: self.avg_rating,
      avg_rating_half_scale: self.avg_rating_half_scale,
      mpaa_rating: self.mpaa_rating,

      similar_movie_ids: self.similar_movies,
      genres: self.genres,
      actors: self.actors,
      director: self.director,
      writer: self.writer,
      critic_reviews: self.critic_reviews }.to_json
    end

    return cached_movie_details
  end
end
