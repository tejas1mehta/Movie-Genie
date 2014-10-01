MovieGenie.Views.GenreShow = Backbone.CompositeView.extend({

  template: JST['genres/show'],
  
  initialize: function(options){
    $(window).bind("scroll", this.$el, this.checkEndPage.bind(this))
    this.listenToOnce(this.collection,"reset", this.renderTemplate)
    this.sortingBy = "predicted_rating";
    this.dataType = options.dataType;
  },

  events: {
    "change #select_sorting" : "sortMoviesOther",       
  },

  sortMoviesOther: function(){
    this.sortingBy = this.$("#select_sorting").val()
    if (this.sortingBy === "predicted_rating"){
      this.collection.comparator = this.collection.predicted_rating_comparator
    } else if (this.sortingBy === "date_released"){
      this.collection.comparator = this.collection.date_released_comparator
    }
    this.collection.sort()
    this.renderTemplate()
  },

  renderTemplate: function(options){
    this.numScrolls = 0;
    var renderedContent = this.template({model: this.model, sortingBy: this.sortingBy, dataType: this.dataType});
    this.$el.html(renderedContent);  
    this.showResults({numberScrolls: 0}) 
  },  
  
  render: function(){   
    $("#loading-data").html(MovieGenie.loadingGenie)
    return this;    
   }

});
_.extend(MovieGenie.Views.GenreShow.prototype, MovieGenie.ViewScrollingMixIn);