MovieGenie.Models.Movie = Backbone.Model.extend({
  urlRoot: "api/movies/",
  
  parse: function (response) {
    MovieGenie.allMovies.add(response,{merge: true});
    delete response;
  },

  isMovieSeen: function(){
    return (this.get("listed") || this.get("rated") || this.get("notInterested"))
  },

  relatedMovies: function(){
    var movieIds = this.get("similar_movie_ids")
    var relatedMovieColn = new MovieGenie.Collections.Movies;
    movieIds.forEach(function(id){
      var movie = MovieGenie.allMovies.get(id)
      if (!movie.isMovieSeen()){relatedMovieColn.add(movie,{sort: false})}
    })

    return relatedMovieColn
  },
});
_.extend(MovieGenie.Models.Movie.prototype, MovieGenie.CollectionMixIn);