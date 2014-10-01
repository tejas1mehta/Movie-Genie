require 'rails_helper'

RSpec.describe Movie, :type => :model do
  it "gives right information hollywood2014" do
    movie = Movie.find_by({title: "Autumn in New York"})
    expect(movie.rt_critics_score).to eq(20) 
    expect(movie.genre7).to eq(1) 
    expect(movie.genre1).to eq(0) 
    expect(movie.avg_rating_half_scale.round(1)).to eq(1.1) 

    expect(movie.actors).to include(Cast.find_by({name: "Richard Gere"}))
    expect(movie.director).to eq(Cast.find_by({name: "Joan Chen"}))
    expect(movie.studio).to eq(Studio.find_by({name: "MGM"}))
    expect(movie.genres).to include(Genre.find_by({title: "Drama"}))
    expect(movie.critic_reviews).to include(MovieCriticJoin.find_by({critic_name: "Owen Gleiberman", movie_id: movie.id}))
  end

  it "gives right information bollywood2014 but in hollwood2014" do
    movie = Movie.find_by({title: "Ek Tha Tiger"})
    expect(movie.rt_critics_score).to eq(60) 
    expect(movie.genre12).to eq(1) 
    expect(movie.genre1).to eq(0) 
    # expect(movie.genre2).to eq(1) 
    # expect(movie.bollywood).to eq(true)         
    expect(movie.avg_rating_half_scale.round(1)).to eq(1.3) 

    expect(movie.actors).to include(Cast.find_by({name: "Salman Khan"}))
    expect(movie.director).to eq(Cast.find_by({name: "Kabir Khan"}))
    expect(movie.studio).to eq(Studio.find_by({name: "Yash Raj Films"}))
    expect(movie.genres).to include(Genre.find_by({title: "Mystery & Suspense"}))
    expect(movie.critic_reviews).to include(MovieCriticJoin.find_by({critic_name: "Ronnie Scheib", movie_id: movie.id}))
  end

  it "gives right information bollywood2014" do
    movie = Movie.find_by({title: "Chashme Buddoor"})
    expect(movie.genre13).to eq(1) 
    expect(movie.genre1).to eq(0) 
    expect(movie.genre2).to eq(1) 
    expect(movie.bollywood).to eq(true)         
    expect(movie.avg_rating_half_scale.round(1)).to eq(0.8) 

    expect(movie.genres).to include(Genre.find_by({title: "Romance"}))
  end

  it "gives right information tv_shows2014" do
    movie = Movie.find_by({title: "Game of Thrones"})
    expect(movie.genre7).to eq(1) 
    expect(movie.genre1).to eq(0) 
    expect(movie.genre16).to eq(1) 
    expect(movie.bollywood).to eq(false)    
    expect(movie.television_show).to eq(true)
    expect(movie.avg_rating_half_scale.round(1)).to eq(2.3)

    expect(movie.actors).to include(Cast.find_by({name: "Lena Headey"}))
    expect(movie.genres).to include(Genre.find_by({title: "Drama"}))
  end  

  it "predicts the right rating" do 
    ratings = Movie.predict_ratings(User.find(1))
    expect(ratings[3939].title).to eq("Game of Thrones")
    expect(ratings[3939].predicted_rating.round(1)).to eq(4.6)
  end
end
