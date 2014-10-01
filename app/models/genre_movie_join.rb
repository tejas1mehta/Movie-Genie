class GenreMovieJoin < ActiveRecord::Base
  belongs_to :genre,
     class_name: "Genre",
     foreign_key: :genre_id

  include UserJoinConcern   
end
