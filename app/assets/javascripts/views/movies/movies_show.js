MovieGenie.Views.MovieShow = Backbone.CompositeView.extend({

  template: JST['movies/show'],

  initialize: function(){
    this.numScrolls = 0;
    $(window).bind("scroll", this.$el, this.checkEndPage.bind(this))    
    this.listenToOnce(this.model,"sync", this.addMovie)
  },

  addMovie: function(){
    // localStorage.setItem( 'movie_' + this.model.id, JSON.stringify(this.model) );    
    $("#loading-data").html("")                        
    var renderedContent = this.template({movie: this.model});
    this.$el.html(renderedContent);    
    var movieMiniView = new MovieGenie.Views.MoviesMiniView({model: this.model});
    this.addSubview("#main-movie", movieMiniView)  
    this.addRelatedMovies()
  },

  addRelatedMovies: function(){
    var view = this;
    this.collection = this.model.relatedMovies();
    this.showResults({numberScrolls: 0})
  },

  render: function(){    
    $("#loading-data").html(MovieGenie.loadingGenie)                    
    return this;    
  }

});
_.extend(MovieGenie.Views.MovieShow.prototype, MovieGenie.ViewScrollingMixIn);
