MovieGenie.ViewScrollingMixIn = {
  checkEndPage: function(){
    if($(window).scrollTop() + $(window).height() >= ($(document).height() - 1)) {
        this.addMoreResults()
    }
  },

  addMoreResults: function(){
    this.numScrolls += 1;
    this.showResults({numberScrolls: this.numScrolls})
  },

  showResults: function(options){
    $("#loading-data").html("")    
    var numberScrolls = options.numberScrolls
    var view = this;
    var showMovies = this.collection.showObjects(numberScrolls);

    showMovies.forEach(function(movie){
      var movieMiniView = new MovieGenie.Views.MoviesMiniView({model: movie});
      view.addSubview("#show-movies", movieMiniView)
    })    
  },
}
