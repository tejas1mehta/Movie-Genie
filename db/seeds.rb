# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# require 'matrix'
require 'spreadsheet'
MAX_RESULTS = 510

genres = Spreadsheet.open('genres.xls')
genres_sheet = genres.worksheet('Sheet1') 
ActiveRecord::Base.transaction do
  i = 1
  guest_user_genres = {}
  while i <= 17
    Genre.create({title: genres_sheet[i, 0]})
    genre_text = "genre" + (i-1).to_s
    guest_user_genres[genre_text.to_sym] = genres_sheet[i, 1]
    i += 1
  end
  user1 = User.create({email:"guest@knowledge.com", name:"Guest", password:"qwerty"}.merge(guest_user_genres))
  dummy_user = User.create({email:"dummy_user@knowledge.com", name:"new_user_rec_movies", password:"qwerty"})


  def insert_movies(book_name, begin_year, end_year, tel_show, bollywood_movie, imdb_genre = false)
    book = Spreadsheet.open(book_name)
    k = begin_year
    while k <= end_year
      sheet_name = "movies" + k.to_s
      # sheet1 = book.create_worksheet :name => sheet_name
      sheet = book.worksheet(sheet_name) # can use an index or worksheet name
      i = 1
      while i <= MAX_RESULTS
        movie_title = sheet[i,1]
        if movie_title && !Movie.find_by({title: movie_title}) && sheet[i,83] != "movie"
          #Creating Movie
          j = 47 
          movie_genres = {}
          while j <= 53
            genre_title = sheet[i, j]
            if genre_title && genre_title != 0 && genre_title != "0" 
              genre = Genre.find_by({title: genre_title})
              if genre 
                genre_text = "genre" + (genre.id-1).to_s
                movie_genres[genre_text.to_sym] = 1
              end
            end
            j += 1
          end

          movie_genres[:genre2] = 1 if bollywood_movie
          movie_genres[:genre16] = 1 if tel_show

          avg_rating_value_temp = sheet[i,86]
          avg_rating_value_temp = 1 if (!avg_rating_value_temp || avg_rating_value_temp.to_f == 0 || avg_rating_value_temp.to_f == 2.5)
          
          photo_link = sheet[i,37]
          if !photo_link || photo_link == "N/A" 
            photo_link = "assets/Image_Unavailable.png"
          elsif sheet[i,23]
            photo_link = "https://s3-us-west-1.amazonaws.com/moviegenie/movieimages/Photo_" + sheet[i,23].to_s + ".png"
          end
          movie = Movie.create({title: sheet[i,1], theatre_release_date: sheet[i,6], dvd_release_date: sheet[i,7],
           imdb_id: sheet[i,23], rt_id: sheet[i,0], years_running: sheet[i,82], television_show: tel_show,
           bollywood: bollywood_movie, plot: sheet[i,34], countries: sheet[i,35], awards: sheet[i,36],
           run_time: sheet[i,4], youtube_trailer_title: sheet[i,43], youtube_trailer: sheet[i,44],
           rt_audience_score: sheet[i,11], rt_critics_score: sheet[i,9], imdb_rating: sheet[i,39],
           imdb_votes: sheet[i,40], avg_rating: sheet[i,85], avg_rating_half_scale: avg_rating_value_temp,
           mpaa_rating: sheet[i,3], photo_link: photo_link}.merge(movie_genres))

          # Creating GenreMovieJoins
          genre_titles = []
          j = 47 
          while j <= 53
            genre_title = sheet[i, j]
            if genre_title && genre_title != "0" && genre_title != 0 && !genre_titles.include?(genre_title)
              genre_titles.push(genre_title)
              genre = Genre.find_by({title: genre_title})
              GenreMovieJoin.create({genre_id: genre.id, movie_id: movie.id}) if genre        
            end
            j += 1
          end
          GenreMovieJoin.create({genre_id: 3, movie_id: movie.id})  if bollywood_movie

        # Creating Actors/Directors etc and their joins
        movie_actors = []
          j = 13
          while j <=17
            actor_name = sheet[i, j]
            if actor_name && !movie_actors.include?(actor_name)
              movie_actors.push(actor_name)
              actor = Cast.find_by({name: actor_name})           
              actor = Cast.create({name: actor_name}) if !actor
              MovieActorJoin.create({actor_id: actor.id, movie_id: movie.id})
            end
            j += 1
          end

          director_name = sheet[i, 54]
          if director_name
              director = Cast.find_by({name: director_name})           
              director = Cast.create({name: director_name}) if !director
              MovieDirectorJoin.create({director_id: director.id, movie_id: movie.id})
          end      

          # writer_name = sheet[i, 33]
          # if writer_name
          #     writer = Cast.find_by({name: writer_name})           
          #     writer = Cast.create({name: writer_name}) if !writer
          #     MovieWriterJoin.create({writer_id: writer.id, movie_id: movie.id})
          # end

          studio_name = sheet[i, 55]
          if studio_name
              studio = Studio.find_by({name: studio_name})           
              studio = Studio.create({name: studio_name}) if !studio
              MovieStudioJoin.create({studio_id: studio.id, movie_id: movie.id})
          end

        # Creating Critic Reviews
          critic_names = []
          j = 0
          while j < 5
            critic_name = sheet[i, 56 + (j*5)]
            if critic_name && !critic_names.include?(critic_name)            
              critic_names.push(critic_name)
              MovieCriticJoin.create({critic_name: critic_name, movie_id: movie.id, freshness: sheet[i, 57 + (j*5)],
                publication: sheet[i, 58 + (j*5)], quote: sheet[i, 59 + (j*5)], review_link: sheet[i, 60 + (j*5)]})
            end
            j += 1
          end
        
          p i
        
          # rescue ActiveRecord::StatementInvalid => e
          #   puts e
          # end
        end
        i += 1
      end
      k += 1
      p k
    end 
  end

  insert_movies('AvgRating_Reviews_RT_IMDB_YT_hollywood_movies_1990-1999.xls', 1990, 1999, false, false)
  insert_movies('AvgRating_Reviews_RT_IMDB_YT_hollywood_movies_2000_2014.xls', 2000, 2014, false, false)
  insert_movies('Scaled_AvgRating_YT_IMDB_top_500_shows.xls', 2015, 2015, true, false)
  insert_movies('AvgRating_Reviews_RT_IMDB_bollywood_movies_2000_2014.xls', 2000, 2014, false, true)   
end



ActiveRecord::Base.transaction do
  UserRatingJoin.create([{user_id: 1, movie_id: 2, movie_rating: 3 },
    {user_id: 1, movie_id: 3, movie_rating: 3 },
    {user_id: 1, movie_id: 4, movie_rating: 4 },
    {user_id: 1, movie_id: 8, movie_rating: 1 },
    {user_id: 1, movie_id: 10, movie_rating: 4 }])

  UserListJoin.create([{user_id: 1, movie_id: 2},
    {user_id: 1, movie_id: 6 },
    {user_id: 1, movie_id: 5 },
    {user_id: 1, movie_id: 12 },
    {user_id: 1, movie_id: 51},
    {user_id: 1, movie_id: 9 },
    {user_id: 1, movie_id: 16 }])

  UserNotInterestedJoin.create([{user_id: 1, movie_id: 12},
    {user_id: 1, movie_id: 17 }])  
end