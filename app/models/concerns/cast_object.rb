# app/models/concerns/taggable.rb
# notice that the file name has to match the module name 
# (applying Rails conventions for autoloading)
module CastObject
  extend ActiveSupport::Concern

  def as_json(options={})
    super(options.merge(:except => [:created_at, :updated_at]))
  end   

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods
    def search(class_name, attribute, keywords)

      all_items = class_name.constantize.all

      keywords_array = keywords.chomp.split(" ").map(&:downcase)
      search_scores = Hash.new(){0}

      all_items.each do |item|
        item_array = item.send(attribute).split(" ").map(&:downcase)
        keywords_included = keywords_array.select{|keyword| item_array.include?(keyword)}
        keywords_included.each{|keyword| search_scores[item] += (keyword.length**2)}
      end

      # results = []
      sorted_results = search_scores.sort_by{|item, rating| rating}.map(&:first).reverse[0, 20]
      return sorted_results
    end 
  end

end