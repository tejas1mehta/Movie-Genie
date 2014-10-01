MovieGenie.Models.Studio = Backbone.Model.extend({
  urlRoot: "api/studios/",

  studioMovies: function(){   
    var studio = this;
    var studioMovies = MovieGenie.allMovies.getObjects(this.get("studio_movie_ids"));

    var applyFilter = function() {
        studioMovies.reset(MovieGenie.allMovies.getObjects(studio.get("studio_movie_ids")).models)
    };
           
    this.bind("sync", applyFilter);  
    return studioMovies
  },
});
