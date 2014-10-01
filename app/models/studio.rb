class Studio < ActiveRecord::Base
  include CastObject

  has_many :studio_movie_joins,
     class_name: "MovieStudioJoin",
     foreign_key: :studio_id    
end
