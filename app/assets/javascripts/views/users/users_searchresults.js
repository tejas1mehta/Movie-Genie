MovieGenie.Views.SearchResults = Backbone.CompositeView.extend({
  template: JST["users/searchresults"],
  
  initialize: function(options){
    MovieGenie.currentRouter.navigate("#users/search")
    $(window).bind("scroll", this.$el, this.checkEndPage.bind(this))  
    this.numScrolls = 0; 
    this.keywords = options.keywords 
    this.matchedModels = this.search(this.keywords);   
  },

  checkEndPage: function(){
    if($(window).scrollTop() + $(window).height() >= ($(document).height() - 1)) {
        this.addMoreResults()
    }
  },

  addMoreResults: function(){
    this.numScrolls += 1;
    this.showResults({numberScrolls: this.numScrolls})
  },

  showObjects: function(numScrolls){
    var startModelIndex = MovieGenie.resultsPerPage*numScrolls;
    var endModelIndex = MovieGenie.resultsPerPage*(numScrolls + 1);
    return this.matchedModels.slice(startModelIndex, endModelIndex)
  },

  showResults: function(options){
    $("#loading-data").html("")    
    var numberScrolls = options.numberScrolls
    var view = this;
    
    var showMovies = this.showObjects(numberScrolls);

    showMovies.forEach(function(movie){
      var movieMiniView = new MovieGenie.Views.MoviesMiniView({model: movie});
      view.addSubview("#show-movies", movieMiniView)
    })    
  },
  
  render: function(){
    renderedContent = this.template({keywords: this.keywords});
    this.$el.html(renderedContent)

    this.showResults({numberScrolls: 0}) 
    return this
  },
  
  search: function(keywords){
    var keywordsArray = keywords.split(" ").map(function(el){ return el.toLowerCase()})

    var searchScores = []
    MovieGenie.allMovies.forEach(function(movie){
      var movieTitle = movie.get("title")
      var movieTitleSplit = movieTitle.split(" ").map(function(el){ return el.toLowerCase()})
      var keywordsIncluded = keywordsArray.filter(function(keyword){
       return _.contains(movieTitleSplit, keyword)
      })
      var movieScore = 0
      keywordsIncluded.forEach(function(keyword){
        movieScore += keyword.length*2
      })
      if (movieScore > 0){ searchScores.push([movie, movieScore]) }
    })

    searchScores = searchScores.sort(function(a, b) {return b[1] - a[1]})
    movieObjects = searchScores.map(function(scoreArray){return scoreArray[0]})
    return movieObjects
  }
});
