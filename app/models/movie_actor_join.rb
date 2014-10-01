class MovieActorJoin < ActiveRecord::Base
  belongs_to :actor,
     class_name: "Cast",
     foreign_key: :actor_id

  include UserJoinConcern   
end
