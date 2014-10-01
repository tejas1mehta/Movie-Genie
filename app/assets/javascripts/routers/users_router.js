MovieGenie.Routers.Users = Backbone.Router.extend({
  initialize: function(options) {
    this.$rootEl = options.$rootEl
    this.$navbar = options.$navbar
  },

  before: function(toRoute){
    $(window).unbind("scroll")
    $("#loading-data").html("")        
    $(".alert-data").html("")

    if (!MovieGenie.currentUser && (toRoute !== "users/new" && toRoute !== "")){
      Backbone.history.navigate("#", { trigger: true })
      return false
    }
  },

  routes: {
    "": "NewSession",
    "users/new": "UserNew",
    "users/settings": "UserSetting",
    "users/get_info": "UserGetInfo",
    "movies/homepage": "Homepage",
    "movies/index" : "RecommendMovies",
    "movies/in_theatre" : "InTheatreMovies",
    "movies/listed" : "ListedMovies",
    "movies/rated" : "RatedMovies",
    "movies/:id" : "ShowMovie",
    "genres/index": "GenresIndex",
    "genres/:id": "ShowGenre",
    "casts/:id": "ShowCast",
    "studios/:id": "ShowStudio",
    "logout": "Logout"
  },

  Homepage: function(){
    var HomePageView = new MovieGenie.Views.MoviesHomePage();
    this._swapView(HomePageView)  
  },

  InTheatreMovies: function(){
    var InTheatreMoviesView = new MovieGenie.Views.MoviesIndex({
      collection: MovieGenie.allMovies.getInTheatreMovies(),
      dataType:"Movies playing in theatre currently:"
    });

    this._swapView(InTheatreMoviesView)    
  },

  UserGetInfo: function(){
    $("#loading-data").html(MovieGenie.loadingGenie)                    
    $.ajax({
      type: "GET",
      url: "/api/users/get_info",
      success: function(response){
        MovieGenie.createSession(response)
        if (MovieGenie.currentUser.get("genres_saved")){
          MovieGenie.currentRouter.navigate("movies/homepage", { trigger: true });          
        } else {
          MovieGenie.currentRouter.navigate("users/settings", { trigger: true });
        }
      }
    })  
  },

  UserSetting: function(){
    MovieGenie.allGenres.fetch();
    var userSettingView = new MovieGenie.Views.UserSetting({ collection: MovieGenie.allGenres });
    this._swapView(userSettingView)    
  },

  GenresIndex: function(){
    MovieGenie.allGenres.fetch();
    var genresIndexView = new MovieGenie.Views.GenresIndex({ collection: MovieGenie.allGenres });
    this._swapView(genresIndexView)    
  },

  ShowGenre: function(id){
    var newGenre = MovieGenie.allGenres.getOrFetch(id)
    var genreView = new MovieGenie.Views.GenreShow({ model: newGenre, collection: newGenre.genreMovies(), dataType: "Genre" });
    this._swapView(genreView)    
  },

  ShowCast: function(id){
    var newCast = MovieGenie.allCasts.getOrFetch(id)
    var castView = new MovieGenie.Views.GenreShow({ model: newCast, collection: newCast.castMovies(), dataType: "Cast" });
    this._swapView(castView)    
  },  

  ShowStudio: function(id){
    var newStudio = MovieGenie.allStudios.getOrFetch(id)
    var studioView = new MovieGenie.Views.GenreShow({ model: newStudio, collection: newStudio.studioMovies(), dataType: "Studio" });
    this._swapView(studioView)    
  },   

  RecommendMovies: function(){
    var recommendMoviesView = new MovieGenie.Views.MoviesIndex({
      collection: MovieGenie.allMovies.notSeenMovies(),
      dataType:"Movies recommended for you:"
    });

    this._swapView(recommendMoviesView)
  },  

  ListedMovies: function(){
    var listedMovies = MovieGenie.allMovies.getListedMovies();
    var listedMoviesView = new MovieGenie.Views.MoviesIndex({
      collection: listedMovies,
      dataType:"My List:"
    });

    this._swapView(listedMoviesView)
  }, 

  RatedMovies: function(){
    var ratedMovies = MovieGenie.allMovies.getRatedMovies();
    var ratedMoviesView = new MovieGenie.Views.MoviesIndex({
      collection: ratedMovies,
      dataType:"My Rated Movies"
    });

    this._swapView(ratedMoviesView)
  }, 

  ShowMovie: function(id){
    var movie = MovieGenie.allMovies.getOrFetch(id)
    var movieView = new MovieGenie.Views.MovieShow({model: movie});

    this._swapView(movieView)
  }, 

  NewSession: function(){
    if (MovieGenie.currentUser){
      MovieGenie.currentRouter.navigate("movies/homepage", { trigger: true });
    } else {
      var newSessionView = new MovieGenie.Views.SessionNew()
      this._swapView(newSessionView)
    }
  },

  UserNew: function(){
    var newUserView = new MovieGenie.Views.UserNew()
    this._swapView(newUserView)
  },

  Logout: function(id){
    $("#navbar").empty()
    $.ajax({
      type: "DELETE",
      url: "/api/session"
    })
    MovieGenie.currentUser = null
    MovieGenie.allMovies = new MovieGenie.Collections.Movies();
    Backbone.history.navigate("", { trigger: true });
  },

  _swapView: function (newView) {
    if (this.currentView) {
      this.currentView.remove();
    }
    this.$rootEl.html(newView.render().$el);
    this.currentView = newView;
  }  
});
