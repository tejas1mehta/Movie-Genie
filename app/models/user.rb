require 'matrix'

class User < ActiveRecord::Base
  before_validation { |user| user.reset_session_token!(false) }

  validates(:session_token,:presence => true)

  validates(:email, :uniqueness => true)

  has_many :listed_movie_joins,
     class_name: "UserListJoin",
     foreign_key: :user_id

  has_many :rated_movie_joins,
     class_name: "UserRatingJoin",
     foreign_key: :user_id

  has_many :not_interested_movie_joins,
     class_name: "UserNotInterestedJoin",
     foreign_key: :user_id
    
  def recommended_movies
    if self.genres_saved == false
      cached_movie_ratings = Rails.cache.fetch("rec_movies_json_new_user1", expires_in: 7.days) do    
        movies = Movie.predict_ratings(User.find_by_name("new_user_rec_movies")).as_json
        movies
      end
    else
      cached_movie_ratings = Rails.cache.fetch("rec_movies_json_#{self.id}", expires_in: 7.days) do    
        movies = Movie.predict_ratings(self).as_json
        movies
      end
    end
    return cached_movie_ratings
    # movies.sort_by(&:predicted_rating).reverse     
  end
  # in percentage
  def genre_interest
    cached_genre_interest = Rails.cache.fetch("genre_interest_final_#{self.id}", expires_in: 7.days) do 
      genres_interest = []   
      j = 0
      genres = Genre.all
      while j < NUM_ALL_GENRES
        genre_text = "genre" + j.to_s
        percent_interest = self.send(genre_text.to_sym)*40.0 + 60 
        genre_hash = {percent_interest: percent_interest, id: j+1, title: genres[j].title}
        genres_interest.push(genre_hash)
        j += 1
      end

      genres_interest
    end

    return cached_genre_interest    
  end
  def get_genre_vector(num_genres = 17)
    user_genre_vector = Matrix.build(num_genres,1){0}    
    j = 0
    while j < num_genres
      genre_text = "genre" + j.to_s
      user_genre_vector[j,0] = self.send(genre_text.to_sym) 
      j += 1
    end

    return user_genre_vector
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth.extra["raw_info"]["name"]
      user.email = auth.extra["raw_info"]["email"]
    end
  end

  # upon signing in, just send the joins to the user not the movies, that way even the rating will be sent 
  def as_json(options={})
    super(options.merge(:except => [ :password_token, :session_token ]))
  end

  def self.generate_unique_token_for_field(field)
    begin
      token = SecureRandom.base64(16)
    end until !self.exists?(field => token)

    token
  end

  def self.generate_session_token
    self.generate_unique_token_for_field(:session_token)
  end

  def self.find_by_credentials(email, secret)
    user = User.find_by_email(email)

    user.is_password?(secret) ? user : nil
  end

  def password=(secret)
    @password = secret
    self.password_token = BCrypt::Password.create(secret).to_s
  end

  def is_password?(secret)
    BCrypt::Password.new(self.password_token).is_password?(secret)
  end

  def reset_session_token!(force = true)
    return unless self.session_token.nil? || force

    self.session_token = User.generate_session_token
    self.save!
  end
end
