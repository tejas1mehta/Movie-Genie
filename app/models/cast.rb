class Cast < ActiveRecord::Base
  include CastObject
  
  validates :name, :presence => true

  has_many :acted_movie_joins,
     class_name: "MovieActorJoin",
     foreign_key: :actor_id

  has_many :directed_movie_joins,
     class_name: "MovieDirectorJoin",
     foreign_key: :director_id

  has_many :written_movie_joins,
     class_name: "MovieWriterJoin",
     foreign_key: :writer_id
  
  def cast_movie_ids
    return self.acted_movie_joins.map(&:movie_id).
    concat(self.directed_movie_joins.map(&:movie_id)).
    concat(self.written_movie_joins.map(&:movie_id))
  end
end
