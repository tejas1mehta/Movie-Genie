# app/models/concerns/taggable.rb
# notice that the file name has to match the module name 
# (applying Rails conventions for autoloading)
module UserJoinConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :movie
  end

  def as_json(options={})
    super(options.merge(:except => [:created_at, :updated_at]))
  end  
end