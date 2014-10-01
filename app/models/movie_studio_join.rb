class MovieStudioJoin < ActiveRecord::Base
  belongs_to :studio,
     class_name: "Studio",
     foreign_key: :studio_id

  include UserJoinConcern 
end
