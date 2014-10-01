MovieGenie.Views.MoviesIndex = Backbone.CompositeView.extend({

  template: JST['movies/index'],

  initialize: function(options){
    $(window).bind("scroll", this.$el, this.checkEndPage.bind(this))
    this.dataType = options.dataType
    this.sortingBy = "predicted_rating"
  },

  events: {
    "change #select_sorting" : "sortMovies",       
  },  

  sortMovies: function(){
    this.sortingBy = this.$("#select_sorting").val()
    if (this.sortingBy === "predicted_rating"){
      this.collection.comparator = this.collection.predicted_rating_comparator
    } else if (this.sortingBy === "date_released"){
      this.collection.comparator = this.collection.date_released_comparator
    }
    this.collection.sort()
    this.render()
  },
  
  render: function(){   
    // var isRecommendations = (this.dataType === "recommendations")
    var renderedContent = this.template({message: this.dataType, sortingBy: this.sortingBy});
    this.$el.html(renderedContent);
    // $("#loading-data").html("<img class='movie-image img-responsive' src='" + MovieGenie.assetsUrl + "/Predicting_genie.gif'>")            

    var view = this;
    this.numScrolls = 0;
    this.showResults({numberScrolls: 0})

    return this;    
   }

});
_.extend(MovieGenie.Views.MoviesIndex.prototype, MovieGenie.ViewScrollingMixIn);
