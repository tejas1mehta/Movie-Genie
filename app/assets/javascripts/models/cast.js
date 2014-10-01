MovieGenie.Models.Cast = Backbone.Model.extend({
  urlRoot: "api/casts/",

  castMovies: function(){   
    var cast = this;
    var castMovies = MovieGenie.allMovies.getObjects(this.get("cast_movie_ids"));

    var applyFilter = function() {
        castMovies.reset(MovieGenie.allMovies.getObjects(cast.get("cast_movie_ids")).models)
    };
           
    this.bind("sync", applyFilter);  
    return castMovies
  },
});
