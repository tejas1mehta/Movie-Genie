MovieGenie.Models.Genre = Backbone.Model.extend({
  urlRoot: "api/genres/",

  parse: function (response) {
    MovieGenie.allGenres.add(response,{merge: true});
    delete response;
  },

  genreMovies: function(){   
    var genre = this;
    var genreMovies = MovieGenie.allMovies.getObjects(this.get("genre_movie_ids"));

    var applyFilter = function() {
        genreMovies.reset(MovieGenie.allMovies.getObjects(genre.get("genre_movie_ids")).models)
    };
           
    this.bind("sync", applyFilter);  
    return genreMovies
  },
});
