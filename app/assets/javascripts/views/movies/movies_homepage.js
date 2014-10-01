MovieGenie.Views.MoviesHomePage = Backbone.CompositeView.extend({

  template: JST['movies/homepage'],

  initialize: function(options){
    $(window).bind("scroll", this.$el, this.checkEndPage.bind(this))
    this.numScrolls = 0;
    this.collection = MovieGenie.allMovies.notSeenMovies();
  },

  addCurrentMovies: function(){
    var view = this;
    var inTheatreMovies = MovieGenie.allMovies.getInTheatreMovies().notSeenMovies();
    var showMovies = inTheatreMovies.models.slice(0, 4);

    showMovies.forEach(function(movie){
      var movieMiniView = new MovieGenie.Views.MoviesMiniView({model: movie});
      view.addSubview("#current-movies", movieMiniView)
    })      
  },

  render: function(){   
    var renderedContent = this.template();
    this.$el.html(renderedContent);

    this.addCurrentMovies()
    this.showResults({numberScrolls: 0})

    return this;    
   }

});
_.extend(MovieGenie.Views.MoviesHomePage.prototype, MovieGenie.ViewScrollingMixIn);
