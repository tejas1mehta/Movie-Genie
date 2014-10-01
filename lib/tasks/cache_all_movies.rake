namespace :db do
    task :cache_movies => :environment do
      load 'cache_movie.rb'
    end
end