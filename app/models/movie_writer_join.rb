class MovieWriterJoin < ActiveRecord::Base
  belongs_to :writer,
     class_name: "Cast",
     foreign_key: :writer_id

  include UserJoinConcern 
end
