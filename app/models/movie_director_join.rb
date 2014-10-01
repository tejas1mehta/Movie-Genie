class MovieDirectorJoin < ActiveRecord::Base
  belongs_to :director,
     class_name: "Cast",
     foreign_key: :director_id

  include UserJoinConcern 
end
