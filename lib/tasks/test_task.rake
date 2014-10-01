namespace :db do
    task :add_new_movies => :environment do
      load 'add_new_movies_db.rb'
    end
end